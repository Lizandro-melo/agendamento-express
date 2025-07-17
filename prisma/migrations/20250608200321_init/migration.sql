/*
  Warnings:

  - You are about to drop the column `chave_pix` on the `pagamento` table. All the data in the column will be lost.
  - You are about to drop the column `token_pagamento` on the `pagamento` table. All the data in the column will be lost.
  - You are about to drop the column `ultimo_numero_cartao` on the `pagamento` table. All the data in the column will be lost.
  - Added the required column `link` to the `pagamento` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `valor` on the `pagamento` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "pagamento" DROP COLUMN "chave_pix",
DROP COLUMN "token_pagamento",
DROP COLUMN "ultimo_numero_cartao",
ADD COLUMN     "link" TEXT NOT NULL,
DROP COLUMN "valor",
ADD COLUMN     "valor" INTEGER NOT NULL;
