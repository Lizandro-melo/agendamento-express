/*
  Warnings:

  - You are about to drop the column `uuid_empresa` on the `Disponibilidade` table. All the data in the column will be lost.
  - You are about to drop the column `cnpj_empresa` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `cpf_dono` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `email_dono` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `login` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `logo_empresa` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `nome_dono` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `nome_empresa` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `numero_celular_dono` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `numero_celular_empresa` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `numero_telefone_empresa` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `senha` on the `Empresa` table. All the data in the column will be lost.
  - Added the required column `uuid_proficional` to the `Agendamento` table without a default value. This is not possible if the table is not empty.
  - Added the required column `uuid_proficional` to the `Disponibilidade` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nome` to the `Empresa` table without a default value. This is not possible if the table is not empty.
  - Added the required column `numero_celular` to the `Empresa` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Disponibilidade" DROP CONSTRAINT "Disponibilidade_uuid_empresa_fkey";

-- AlterTable
ALTER TABLE "Agendamento" ADD COLUMN     "uuid_proficional" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Disponibilidade" DROP COLUMN "uuid_empresa",
ADD COLUMN     "uuid_agendamento" TEXT,
ADD COLUMN     "uuid_proficional" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Empresa" DROP COLUMN "cnpj_empresa",
DROP COLUMN "cpf_dono",
DROP COLUMN "email_dono",
DROP COLUMN "login",
DROP COLUMN "logo_empresa",
DROP COLUMN "nome_dono",
DROP COLUMN "nome_empresa",
DROP COLUMN "numero_celular_dono",
DROP COLUMN "numero_celular_empresa",
DROP COLUMN "numero_telefone_empresa",
DROP COLUMN "senha",
ADD COLUMN     "cnpj" TEXT,
ADD COLUMN     "logo" TEXT,
ADD COLUMN     "nome" TEXT NOT NULL,
ADD COLUMN     "numero_celular" TEXT NOT NULL,
ADD COLUMN     "numero_telefone" TEXT;

-- CreateTable
CREATE TABLE "Proficional" (
    "uuid_proficional" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "numero_celular" TEXT NOT NULL,
    "login" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "redes" JSONB,
    "cpf" TEXT NOT NULL,
    "uuid_empresa" TEXT NOT NULL,

    CONSTRAINT "Proficional_pkey" PRIMARY KEY ("uuid_proficional")
);

-- CreateIndex
CREATE UNIQUE INDEX "Proficional_uuid_proficional_key" ON "Proficional"("uuid_proficional");

-- AddForeignKey
ALTER TABLE "Proficional" ADD CONSTRAINT "Proficional_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "Empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agendamento" ADD CONSTRAINT "Agendamento_uuid_proficional_fkey" FOREIGN KEY ("uuid_proficional") REFERENCES "Proficional"("uuid_proficional") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Disponibilidade" ADD CONSTRAINT "Disponibilidade_uuid_proficional_fkey" FOREIGN KEY ("uuid_proficional") REFERENCES "Proficional"("uuid_proficional") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Disponibilidade" ADD CONSTRAINT "Disponibilidade_uuid_agendamento_fkey" FOREIGN KEY ("uuid_agendamento") REFERENCES "Agendamento"("uuid_agendamento") ON DELETE SET NULL ON UPDATE CASCADE;
