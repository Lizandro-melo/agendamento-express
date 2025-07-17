/*
  Warnings:

  - You are about to drop the column `uuid_empresa` on the `proficional` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "proficional" DROP CONSTRAINT "proficional_uuid_empresa_fkey";

-- AlterTable
ALTER TABLE "proficional" DROP COLUMN "uuid_empresa";
