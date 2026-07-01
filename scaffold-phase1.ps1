# SyncSlot Phase 1 — Project Architecture Scaffold
# Run from C:\Users\ishfatech\Documents\SyncSlot\syncslot
#
# This creates empty folders for the app's route/component/service structure.
# Next.js needs at least a page.tsx/route.ts inside route folders to treat them
# as real routes — we'll add those in later phases as we build each feature.
# For now this just lays out the skeleton so imports and file placement have a home.

# --- app/(public) ---
New-Item -ItemType Directory -Force -Path "app/(public)/login"
New-Item -ItemType Directory -Force -Path "app/(public)/signup"
New-Item -ItemType Directory -Force -Path "app/(public)/forgot-password"
New-Item -ItemType Directory -Force -Path "app/(public)/[username]/[eventSlug]/confirmed"
New-Item -ItemType Directory -Force -Path "app/(public)/booking/[rescheduleToken]"

# --- app/(dashboard) ---
New-Item -ItemType Directory -Force -Path "app/(dashboard)/dashboard/event-types/[id]"
New-Item -ItemType Directory -Force -Path "app/(dashboard)/dashboard/availability"
New-Item -ItemType Directory -Force -Path "app/(dashboard)/dashboard/bookings"
New-Item -ItemType Directory -Force -Path "app/(dashboard)/dashboard/integrations"
New-Item -ItemType Directory -Force -Path "app/(dashboard)/dashboard/analytics"
New-Item -ItemType Directory -Force -Path "app/(dashboard)/dashboard/settings/profile"
New-Item -ItemType Directory -Force -Path "app/(dashboard)/dashboard/settings/billing"

# --- app/api ---
New-Item -ItemType Directory -Force -Path "app/api/auth/[...nextauth]"
New-Item -ItemType Directory -Force -Path "app/api/event-types/[id]"
New-Item -ItemType Directory -Force -Path "app/api/schedules/[id]"
New-Item -ItemType Directory -Force -Path "app/api/public/[username]/[eventSlug]/slots"
New-Item -ItemType Directory -Force -Path "app/api/public/[username]/[eventSlug]/book"
New-Item -ItemType Directory -Force -Path "app/api/public/bookings/[rescheduleToken]/reschedule"
New-Item -ItemType Directory -Force -Path "app/api/public/bookings/[rescheduleToken]/cancel"
New-Item -ItemType Directory -Force -Path "app/api/calendar/connect/google"
New-Item -ItemType Directory -Force -Path "app/api/calendar/connect/microsoft"
New-Item -ItemType Directory -Force -Path "app/api/bookings"
New-Item -ItemType Directory -Force -Path "app/api/analytics"
New-Item -ItemType Directory -Force -Path "app/api/users/me"

# --- components ---
New-Item -ItemType Directory -Force -Path "components/layout"
New-Item -ItemType Directory -Force -Path "components/event-types"
New-Item -ItemType Directory -Force -Path "components/availability"
New-Item -ItemType Directory -Force -Path "components/booking"
New-Item -ItemType Directory -Force -Path "components/dashboard"

# --- server ---
New-Item -ItemType Directory -Force -Path "server/services"

# --- lib/validations ---
New-Item -ItemType Directory -Force -Path "lib/validations"

Write-Host "Phase 1 scaffold complete." -ForegroundColor Green
