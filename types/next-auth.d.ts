import { DefaultSession } from "next-auth";

declare module "next-auth" {
  interface Session {
    user: {
      id: string;
      username: string;
      onboardingDone: boolean;
    } & DefaultSession["user"];
  }

  interface User {
    username?: string;
    onboardingDone?: boolean;
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    id?: string;
    username?: string;
    onboardingDone?: boolean;
  }
}