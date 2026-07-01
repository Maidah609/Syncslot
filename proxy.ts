import { auth } from "@/server/auth";
import { NextResponse } from "next/server";

// As of Next.js 16, this file replaces the old middleware.ts.
// It runs on every request matching the `matcher` config below.
export default auth((req) => {
  const isLoggedIn = !!req.auth;
  const isOnDashboard = req.nextUrl.pathname.startsWith("/dashboard");

  if (isOnDashboard && !isLoggedIn) {
    const loginUrl = new URL("/login", req.nextUrl.origin);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
});

export const config = {
  // Only run this check on dashboard routes — public/booking pages and
  // API routes handle their own access rules separately.
  matcher: ["/dashboard/:path*"],
};