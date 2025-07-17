/*
  Warnings:

  - Made the column `cnpj` on table `empresa` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "empresa" ALTER COLUMN "cnpj" SET NOT NULL;
