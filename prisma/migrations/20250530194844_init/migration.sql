/*
  Warnings:

  - A unique constraint covering the columns `[cnpj]` on the table `empresa` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[login]` on the table `proficional` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[cpf]` on the table `proficional` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[login]` on the table `user` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "empresa_cnpj_key" ON "empresa"("cnpj");

-- CreateIndex
CREATE UNIQUE INDEX "proficional_login_key" ON "proficional"("login");

-- CreateIndex
CREATE UNIQUE INDEX "proficional_cpf_key" ON "proficional"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "user_login_key" ON "user"("login");
