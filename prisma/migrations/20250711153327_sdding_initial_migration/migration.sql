-- CreateEnum
CREATE TYPE "MessageType" AS ENUM ('TEXT', 'IMAGE', 'VOICE', 'VIDEO', 'DOCUMENT', 'POLL', 'EMOJI', 'STICKER', 'LOCATION', 'CONTACT', 'OTHER');

-- CreateTable
CREATE TABLE "superUser" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdById" TEXT,
    "updatedById" TEXT,

    CONSTRAINT "superUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "communicationChannel" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdById" TEXT,
    "updatedById" TEXT,

    CONSTRAINT "communicationChannel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "typeOfMessage" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "recivedFromChannel" BOOLEAN DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdById" TEXT,
    "updatedById" TEXT,
    "responseStructure" JSONB,

    CONSTRAINT "typeOfMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdById" TEXT,
    "updatedById" TEXT,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "channelUsername" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "metaData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "communicationChannelId" TEXT NOT NULL,
    "createdById" TEXT,
    "updatedById" TEXT,

    CONSTRAINT "channelUsername_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chatHistory" (
    "id" TEXT NOT NULL,
    "messageType" "MessageType" NOT NULL,
    "content" TEXT,
    "mediaUrl" TEXT,
    "mediaData" BYTEA,
    "metadata" JSONB,
    "externalId" TEXT,
    "expiresAt" TIMESTAMP(3),
    "isExpired" BOOLEAN NOT NULL DEFAULT false,
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "communicationChannelId" TEXT NOT NULL,

    CONSTRAINT "chatHistory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "superUser_email_key" ON "superUser"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "channelUsername_userId_communicationChannelId_key" ON "channelUsername"("userId", "communicationChannelId");

-- CreateIndex
CREATE INDEX "chatHistory_userId_idx" ON "chatHistory"("userId");

-- CreateIndex
CREATE INDEX "chatHistory_communicationChannelId_idx" ON "chatHistory"("communicationChannelId");

-- CreateIndex
CREATE INDEX "chatHistory_expiresAt_idx" ON "chatHistory"("expiresAt");

-- CreateIndex
CREATE INDEX "chatHistory_isExpired_idx" ON "chatHistory"("isExpired");

-- AddForeignKey
ALTER TABLE "superUser" ADD CONSTRAINT "superUser_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "superUser" ADD CONSTRAINT "superUser_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communicationChannel" ADD CONSTRAINT "communicationChannel_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communicationChannel" ADD CONSTRAINT "communicationChannel_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "typeOfMessage" ADD CONSTRAINT "typeOfMessage_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "typeOfMessage" ADD CONSTRAINT "typeOfMessage_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channelUsername" ADD CONSTRAINT "channelUsername_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channelUsername" ADD CONSTRAINT "channelUsername_communicationChannelId_fkey" FOREIGN KEY ("communicationChannelId") REFERENCES "communicationChannel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channelUsername" ADD CONSTRAINT "channelUsername_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channelUsername" ADD CONSTRAINT "channelUsername_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "superUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chatHistory" ADD CONSTRAINT "chatHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chatHistory" ADD CONSTRAINT "chatHistory_communicationChannelId_fkey" FOREIGN KEY ("communicationChannelId") REFERENCES "communicationChannel"("id") ON DELETE CASCADE ON UPDATE CASCADE;
