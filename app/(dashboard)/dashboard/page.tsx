import { auth } from "@/server/auth";

export default async function DashboardPage() {
  const session = await auth();

  return (
    <div>
      <h1 className="text-2xl font-semibold">
        Welcome, {session?.user?.name}
      </h1>
      <p className="mt-2 text-muted-foreground">
        Your dashboard is under construction — event types, availability, and
        bookings are coming in the next phases.
      </p>
    </div>
  );
}