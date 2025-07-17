/*
  Warnings:

  - You are about to drop the column `nome` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `numero_celular` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `numero_telefone` on the `Empresa` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `Proficional` table. All the data in the column will be lost.
  - You are about to drop the column `nome` on the `Proficional` table. All the data in the column will be lost.
  - You are about to drop the column `numero_celular` on the `Proficional` table. All the data in the column will be lost.
  - Added the required column `email_empresa` to the `Empresa` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nome_empresa` to the `Empresa` table without a default value. This is not possible if the table is not empty.
  - Added the required column `numero_celular_empresa` to the `Empresa` table without a default value. This is not possible if the table is not empty.
  - Added the required column `email_proficional` to the `Proficional` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nome_proficional` to the `Proficional` table without a default value. This is not possible if the table is not empty.
  - Added the required column `numero_celular_proficional` to the `Proficional` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Empresa" DROP COLUMN "nome",
DROP COLUMN "numero_celular",
DROP COLUMN "numero_telefone",
ADD COLUMN     "email_empresa" TEXT NOT NULL,
ADD COLUMN     "nome_empresa" TEXT NOT NULL,
ADD COLUMN     "numero_celular_empresa" TEXT NOT NULL,
ADD COLUMN     "numero_telefone_empresa" TEXT;

-- AlterTable
ALTER TABLE "Proficional" DROP COLUMN "email",
DROP COLUMN "nome",
DROP COLUMN "numero_celular",
ADD COLUMN     "email_proficional" TEXT NOT NULL,
ADD COLUMN     "nome_proficional" TEXT NOT NULL,
ADD COLUMN     "numero_celular_proficional" TEXT NOT NULL;
