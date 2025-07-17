/*
  Warnings:

  - Added the required column `valor_pagamento` to the `empresa` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "empresa" DROP COLUMN "valor_pagamento",
ADD COLUMN     "valor_pagamento" INTEGER NOT NULL;
