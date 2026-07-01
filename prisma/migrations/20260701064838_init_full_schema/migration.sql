/*
  Warnings:

  - You are about to drop the column `guestEmail` on the `Booking` table. All the data in the column will be lost.
  - You are about to drop the column `guestName` on the `Booking` table. All the data in the column will be lost.
  - You are about to drop the column `notes` on the `Booking` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Booking` table. All the data in the column will be lost.
  - The `status` column on the `Booking` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `duration` on the `EventType` table. All the data in the column will be lost.
  - You are about to drop the column `image` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `Availability` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[rescheduleToken]` on the table `Booking` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId,slug]` on the table `EventType` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[username]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `hostId` to the `Booking` table without a default value. This is not possible if the table is not empty.
  - Added the required column `inviteeEmail` to the `Booking` table without a default value. This is not possible if the table is not empty.
  - Added the required column `inviteeName` to the `Booking` table without a default value. This is not possible if the table is not empty.
  - Added the required column `inviteeTimezone` to the `Booking` table without a default value. This is not possible if the table is not empty.
  - The required column `rescheduleToken` was added to the `Booking` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.
  - Added the required column `durationMinutes` to the `EventType` table without a default value. This is not possible if the table is not empty.
  - Added the required column `locationType` to the `EventType` table without a default value. This is not possible if the table is not empty.
  - Added the required column `slug` to the `EventType` table without a default value. This is not possible if the table is not empty.
  - Added the required column `username` to the `User` table without a default value. This is not possible if the table is not empty.
  - Made the column `name` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "Plan" AS ENUM ('FREE', 'PRO', 'TEAM');

-- CreateEnum
CREATE TYPE "LocationType" AS ENUM ('ZOOM', 'GOOGLE_MEET', 'PHONE', 'IN_PERSON', 'CUSTOM');

-- CreateEnum
CREATE TYPE "QuestionType" AS ENUM ('TEXT', 'MULTIPLE_CHOICE', 'YES_NO');

-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('CONFIRMED', 'CANCELLED', 'RESCHEDULED');

-- CreateEnum
CREATE TYPE "CalendarProvider" AS ENUM ('GOOGLE', 'MICROSOFT');

-- DropForeignKey
ALTER TABLE "Availability" DROP CONSTRAINT "Availability_userId_fkey";

-- DropForeignKey
ALTER TABLE "Booking" DROP CONSTRAINT "Booking_userId_fkey";

-- AlterTable
ALTER TABLE "Booking" DROP COLUMN "guestEmail",
DROP COLUMN "guestName",
DROP COLUMN "notes",
DROP COLUMN "userId",
ADD COLUMN     "answers" JSONB,
ADD COLUMN     "calendarEventId" TEXT,
ADD COLUMN     "cancelReason" TEXT,
ADD COLUMN     "hostId" TEXT NOT NULL,
ADD COLUMN     "inviteeEmail" TEXT NOT NULL,
ADD COLUMN     "inviteeName" TEXT NOT NULL,
ADD COLUMN     "inviteeTimezone" TEXT NOT NULL,
ADD COLUMN     "rescheduleToken" TEXT NOT NULL,
ADD COLUMN     "videoLink" TEXT,
DROP COLUMN "status",
ADD COLUMN     "status" "BookingStatus" NOT NULL DEFAULT 'CONFIRMED';

-- AlterTable
ALTER TABLE "EventType" DROP COLUMN "duration",
ADD COLUMN     "bufferAfter" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "bufferBefore" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "color" TEXT,
ADD COLUMN     "durationMinutes" INTEGER NOT NULL,
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "locationType" "LocationType" NOT NULL,
ADD COLUMN     "locationValue" TEXT,
ADD COLUMN     "maxFutureDays" INTEGER NOT NULL DEFAULT 60,
ADD COLUMN     "minNoticeMins" INTEGER NOT NULL DEFAULT 60,
ADD COLUMN     "scheduleId" TEXT,
ADD COLUMN     "slug" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "image",
DROP COLUMN "password",
ADD COLUMN     "avatarUrl" TEXT,
ADD COLUMN     "brandColor" TEXT,
ADD COLUMN     "onboardingDone" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "passwordHash" TEXT,
ADD COLUMN     "plan" "Plan" NOT NULL DEFAULT 'FREE',
ADD COLUMN     "username" TEXT NOT NULL,
ADD COLUMN     "welcomeMessage" TEXT,
ALTER COLUMN "name" SET NOT NULL;

-- DropTable
DROP TABLE "Availability";

-- CreateTable
CREATE TABLE "BookingQuestion" (
    "id" TEXT NOT NULL,
    "eventTypeId" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "type" "QuestionType" NOT NULL,
    "required" BOOLEAN NOT NULL DEFAULT true,
    "options" TEXT[],

    CONSTRAINT "BookingQuestion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Schedule" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "timezone" TEXT NOT NULL,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AvailabilityRule" (
    "id" TEXT NOT NULL,
    "scheduleId" TEXT NOT NULL,
    "dayOfWeek" INTEGER NOT NULL,
    "startTime" TEXT NOT NULL,
    "endTime" TEXT NOT NULL,

    CONSTRAINT "AvailabilityRule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DateOverride" (
    "id" TEXT NOT NULL,
    "scheduleId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "isUnavailable" BOOLEAN NOT NULL DEFAULT true,
    "startTime" TEXT,
    "endTime" TEXT,

    CONSTRAINT "DateOverride_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalendarAccount" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "provider" "CalendarProvider" NOT NULL,
    "accessToken" TEXT NOT NULL,
    "refreshToken" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "externalEmail" TEXT NOT NULL,

    CONSTRAINT "CalendarAccount_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "BookingQuestion_eventTypeId_idx" ON "BookingQuestion"("eventTypeId");

-- CreateIndex
CREATE INDEX "Schedule_userId_idx" ON "Schedule"("userId");

-- CreateIndex
CREATE INDEX "AvailabilityRule_scheduleId_idx" ON "AvailabilityRule"("scheduleId");

-- CreateIndex
CREATE INDEX "DateOverride_scheduleId_idx" ON "DateOverride"("scheduleId");

-- CreateIndex
CREATE INDEX "CalendarAccount_userId_idx" ON "CalendarAccount"("userId");

-- CreateIndex
CREATE INDEX "Account_userId_idx" ON "Account"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Booking_rescheduleToken_key" ON "Booking"("rescheduleToken");

-- CreateIndex
CREATE INDEX "Booking_hostId_idx" ON "Booking"("hostId");

-- CreateIndex
CREATE INDEX "Booking_eventTypeId_idx" ON "Booking"("eventTypeId");

-- CreateIndex
CREATE INDEX "Booking_startTime_idx" ON "Booking"("startTime");

-- CreateIndex
CREATE INDEX "EventType_userId_idx" ON "EventType"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "EventType_userId_slug_key" ON "EventType"("userId", "slug");

-- CreateIndex
CREATE INDEX "Session_userId_idx" ON "Session"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- AddForeignKey
ALTER TABLE "EventType" ADD CONSTRAINT "EventType_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES "Schedule"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BookingQuestion" ADD CONSTRAINT "BookingQuestion_eventTypeId_fkey" FOREIGN KEY ("eventTypeId") REFERENCES "EventType"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Schedule" ADD CONSTRAINT "Schedule_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AvailabilityRule" ADD CONSTRAINT "AvailabilityRule_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES "Schedule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DateOverride" ADD CONSTRAINT "DateOverride_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES "Schedule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Booking" ADD CONSTRAINT "Booking_hostId_fkey" FOREIGN KEY ("hostId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalendarAccount" ADD CONSTRAINT "CalendarAccount_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
