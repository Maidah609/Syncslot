import NextAuth from "next-auth";
import Credentials from "next-auth/providers/credentials";
import { PrismaAdapter } from "@auth/prisma-adapter";
import bcrypt from "bcryptjs";
import prisma from "@/lib/prisma";
import { loginSchema } from "@/lib/validations/auth";

export const { handlers, signIn, signOut, auth } = NextAuth({
  // The Prisma adapter persists users/accounts/sessions to our DB.
  // NOTE: adapter + Credentials provider together requires session
  // strategy "jwt" — Auth.js does not support database sessions when
  // a Credentials provider is present. The adapter still matters here
  // because Google/Microsoft OAuth (added later) will use it to store
  // linked accounts.
  adapter: PrismaAdapter(prisma),
  session: { strategy: "jwt" },
  pages: {
    signIn: "/login",
  },
  providers: [
    Credentials({
      name: "credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        const parsed = loginSchema.safeParse(credentials);
        if (!parsed.success) return null;

        const { email, password } = parsed.data;

        const user = await prisma.user.findUnique({ where: { email } });
        if (!user || !user.passwordHash) return null;

        const isValid = await bcrypt.compare(password, user.passwordHash);
        if (!isValid) return null;

        return {
          id: user.id,
          name: user.name,
          email: user.email,
          username: user.username,
          onboardingDone: user.onboardingDone,
        };
      },
    }),
  ],
  callbacks: {
    // Runs whenever a JWT is created/updated. We stash extra fields on
    // the token so they're available in the session callback below
    // without an extra DB query on every request.
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.username = (user as { username?: string }).username;
        token.onboardingDone = (
          user as { onboardingDone?: boolean }
        ).onboardingDone;
      }
      return token;
    },
    // Runs whenever session data is checked (e.g. useSession(), auth()).
    // Exposes the fields we stashed in the JWT to the client/server.
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string;
        session.user.username = token.username as string;
        session.user.onboardingDone = token.onboardingDone as boolean;
      }
      return session;
    },
  },
});