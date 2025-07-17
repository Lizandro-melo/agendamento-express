/*
  Warnings:

  - You are about to drop the column `login` on the `proficional` table. All the data in the column will be lost.
  - You are about to drop the column `login` on the `user` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[email_proficional]` on the table `proficional` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[numero_celular_proficional]` on the table `proficional` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[numero_celular_user]` on the table `user` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[email]` on the table `user` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "proficional_login_key";

-- DropIndex
DROP INDEX "user_login_key";

-- AlterTable
ALTER TABLE "proficional" DROP COLUMN "login";

-- AlterTable
ALTER TABLE "user" DROP COLUMN "login";

-- CreateIndex
CREATE UNIQUE INDEX "proficional_email_proficional_key" ON "proficional"("email_proficional");

-- CreateIndex
CREATE UNIQUE INDEX "proficional_numero_celular_proficional_key" ON "proficional"("numero_celular_proficional");

-- CreateIndex
CREATE UNIQUE INDEX "user_numero_celular_user_key" ON "user"("numero_celular_user");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");
