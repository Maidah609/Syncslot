import { auth } from "@/server/auth";
import { redirect } from "next/navigation";
import { LogoutButton } from "@/components/layout/logout-button";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await auth();

  // Belt-and-suspenders: proxy.ts already redirects unauthenticated users,
  // but checking again here means this layout is safe even if used
  // somewhere the proxy matcher doesn't cover.
  if (!session?.user) {
    redirect("/login");
  }

  return (
    <div className="min-h-screen">
      <header className="flex items-center justify-between border-b px-6 py-4">
        <p className="text-sm text-muted-foreground">
          Logged in as {session.user.email}
        </p>
        <LogoutButton />
      </header>
      <main className="p-6">{children}</main>
    </div>
  );
}