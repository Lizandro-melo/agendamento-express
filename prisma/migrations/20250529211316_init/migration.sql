/*
  Warnings:

  - You are about to drop the `Agendamento` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Agendamento_servico` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Disponibilidade` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Empresa` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Pagamento` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Proficional` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Servico_add` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Servico_principais` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Subservico` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User_empresa` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Agendamento" DROP CONSTRAINT "Agendamento_uuid_proficional_fkey";

-- DropForeignKey
ALTER TABLE "Agendamento" DROP CONSTRAINT "Agendamento_uuid_subservico_fkey";

-- DropForeignKey
ALTER TABLE "Agendamento" DROP CONSTRAINT "Agendamento_uuid_user_fkey";

-- DropForeignKey
ALTER TABLE "Agendamento_servico" DROP CONSTRAINT "Agendamento_servico_uuid_agendamento_fkey";

-- DropForeignKey
ALTER TABLE "Agendamento_servico" DROP CONSTRAINT "Agendamento_servico_uuid_servico_add_fkey";

-- DropForeignKey
ALTER TABLE "Disponibilidade" DROP CONSTRAINT "Disponibilidade_uuid_agendamento_fkey";

-- DropForeignKey
ALTER TABLE "Disponibilidade" DROP CONSTRAINT "Disponibilidade_uuid_proficional_fkey";

-- DropForeignKey
ALTER TABLE "Pagamento" DROP CONSTRAINT "Pagamento_uuid_empresa_fkey";

-- DropForeignKey
ALTER TABLE "Proficional" DROP CONSTRAINT "Proficional_uuid_empresa_fkey";

-- DropForeignKey
ALTER TABLE "Servico_principais" DROP CONSTRAINT "Servico_principais_empresa_uuid_empresa_fkey";

-- DropForeignKey
ALTER TABLE "Subservico" DROP CONSTRAINT "Subservico_uuid_servico_principal_fkey";

-- DropForeignKey
ALTER TABLE "User_empresa" DROP CONSTRAINT "User_empresa_uuid_empresa_fkey";

-- DropForeignKey
ALTER TABLE "User_empresa" DROP CONSTRAINT "User_empresa_uuid_user_fkey";

-- DropTable
DROP TABLE "Agendamento";

-- DropTable
DROP TABLE "Agendamento_servico";

-- DropTable
DROP TABLE "Disponibilidade";

-- DropTable
DROP TABLE "Empresa";

-- DropTable
DROP TABLE "Pagamento";

-- DropTable
DROP TABLE "Proficional";

-- DropTable
DROP TABLE "Servico_add";

-- DropTable
DROP TABLE "Servico_principais";

-- DropTable
DROP TABLE "Subservico";

-- DropTable
DROP TABLE "User";

-- DropTable
DROP TABLE "User_empresa";

-- CreateTable
CREATE TABLE "user" (
    "uuid_user" TEXT NOT NULL,
    "name_user" TEXT NOT NULL,
    "numero_celular_user" TEXT NOT NULL,
    "email" TEXT,
    "login" TEXT,
    "senha" TEXT,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "alterado" TIMESTAMP(3),

    CONSTRAINT "user_pkey" PRIMARY KEY ("uuid_user")
);

-- CreateTable
CREATE TABLE "empresa" (
    "uuid_empresa" TEXT NOT NULL,
    "nome_empresa" TEXT NOT NULL,
    "email_empresa" TEXT NOT NULL,
    "redes" JSONB,
    "numero_celular_empresa" TEXT NOT NULL,
    "numero_telefone_empresa" TEXT,
    "logo" TEXT,
    "cnpj" TEXT,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "alterado" TIMESTAMP(3),
    "plano_pagamento" TEXT,
    "dias_tolerancia" INTEGER NOT NULL DEFAULT 7,

    CONSTRAINT "empresa_pkey" PRIMARY KEY ("uuid_empresa")
);

-- CreateTable
CREATE TABLE "proficional" (
    "uuid_proficional" TEXT NOT NULL,
    "nome_proficional" TEXT NOT NULL,
    "email_proficional" TEXT NOT NULL,
    "numero_celular_proficional" TEXT NOT NULL,
    "login" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "redes" JSONB,
    "cpf" TEXT NOT NULL,
    "uuid_empresa" TEXT NOT NULL,

    CONSTRAINT "proficional_pkey" PRIMARY KEY ("uuid_proficional")
);

-- CreateTable
CREATE TABLE "user_empresa" (
    "id" SERIAL NOT NULL,
    "uuid_user" TEXT NOT NULL,
    "uuid_empresa" TEXT NOT NULL,

    CONSTRAINT "user_empresa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "servico_principais" (
    "uuid_servico_principal" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "logo" TEXT,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "empresa_uuid_empresa" TEXT NOT NULL,

    CONSTRAINT "servico_principais_pkey" PRIMARY KEY ("uuid_servico_principal")
);

-- CreateTable
CREATE TABLE "subservico" (
    "uuid_subservico" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "valor" DECIMAL(65,30) NOT NULL,
    "descricao" TEXT,
    "duracao" TIMESTAMP(3) NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "uuid_servico_principal" TEXT NOT NULL,

    CONSTRAINT "subservico_pkey" PRIMARY KEY ("uuid_subservico")
);

-- CreateTable
CREATE TABLE "servico_add" (
    "uuid_servico_add" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "valor" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "duracao" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "servico_add_pkey" PRIMARY KEY ("uuid_servico_add")
);

-- CreateTable
CREATE TABLE "agendamento" (
    "uuid_agendamento" TEXT NOT NULL,
    "uuid_subservico" TEXT NOT NULL,
    "valor_total" DECIMAL(65,30) NOT NULL,
    "duracao" TIMESTAMP(3) NOT NULL,
    "data_agendamento" TIMESTAMP(3) NOT NULL,
    "pago" BOOLEAN NOT NULL DEFAULT false,
    "metodo_pagamento" "Metodo_pagamento",
    "token_pagamento" TEXT,
    "ultimo_numero_cartao" TEXT,
    "uuid_user" TEXT NOT NULL,
    "chave_pix" TEXT,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "uuid_proficional" TEXT NOT NULL,

    CONSTRAINT "agendamento_pkey" PRIMARY KEY ("uuid_agendamento")
);

-- CreateTable
CREATE TABLE "agendamento_servico" (
    "id" SERIAL NOT NULL,
    "uuid_servico_add" TEXT NOT NULL,
    "uuid_agendamento" TEXT NOT NULL,

    CONSTRAINT "agendamento_servico_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pagamento" (
    "uuid_pagamento" TEXT NOT NULL,
    "uuid_empresa" TEXT NOT NULL,
    "pago" BOOLEAN NOT NULL DEFAULT false,
    "valor" TEXT NOT NULL,
    "metodo_pagamento" "Metodo_pagamento" NOT NULL,
    "ultimo_numero_cartao" TEXT,
    "chave_pix" TEXT,
    "token_pagamento" TEXT,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_vencimento" TIMESTAMP(3),

    CONSTRAINT "pagamento_pkey" PRIMARY KEY ("uuid_pagamento")
);

-- CreateTable
CREATE TABLE "disponibilidade" (
    "id" SERIAL NOT NULL,
    "data_hora" TIMESTAMP(3) NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "uuid_proficional" TEXT NOT NULL,
    "uuid_agendamento" TEXT,

    CONSTRAINT "disponibilidade_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_uuid_user_key" ON "user"("uuid_user");

-- CreateIndex
CREATE UNIQUE INDEX "empresa_uuid_empresa_key" ON "empresa"("uuid_empresa");

-- CreateIndex
CREATE UNIQUE INDEX "proficional_uuid_proficional_key" ON "proficional"("uuid_proficional");

-- CreateIndex
CREATE UNIQUE INDEX "servico_principais_uuid_servico_principal_key" ON "servico_principais"("uuid_servico_principal");

-- CreateIndex
CREATE UNIQUE INDEX "subservico_uuid_subservico_key" ON "subservico"("uuid_subservico");

-- CreateIndex
CREATE UNIQUE INDEX "servico_add_uuid_servico_add_key" ON "servico_add"("uuid_servico_add");

-- CreateIndex
CREATE UNIQUE INDEX "agendamento_uuid_agendamento_key" ON "agendamento"("uuid_agendamento");

-- CreateIndex
CREATE UNIQUE INDEX "agendamento_servico_id_key" ON "agendamento_servico"("id");

-- CreateIndex
CREATE UNIQUE INDEX "pagamento_uuid_pagamento_key" ON "pagamento"("uuid_pagamento");

-- CreateIndex
CREATE UNIQUE INDEX "disponibilidade_id_key" ON "disponibilidade"("id");

-- AddForeignKey
ALTER TABLE "proficional" ADD CONSTRAINT "proficional_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_empresa" ADD CONSTRAINT "user_empresa_uuid_user_fkey" FOREIGN KEY ("uuid_user") REFERENCES "user"("uuid_user") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_empresa" ADD CONSTRAINT "user_empresa_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "servico_principais" ADD CONSTRAINT "servico_principais_empresa_uuid_empresa_fkey" FOREIGN KEY ("empresa_uuid_empresa") REFERENCES "empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subservico" ADD CONSTRAINT "subservico_uuid_servico_principal_fkey" FOREIGN KEY ("uuid_servico_principal") REFERENCES "servico_principais"("uuid_servico_principal") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamento" ADD CONSTRAINT "agendamento_uuid_user_fkey" FOREIGN KEY ("uuid_user") REFERENCES "user"("uuid_user") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamento" ADD CONSTRAINT "agendamento_uuid_subservico_fkey" FOREIGN KEY ("uuid_subservico") REFERENCES "subservico"("uuid_subservico") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamento" ADD CONSTRAINT "agendamento_uuid_proficional_fkey" FOREIGN KEY ("uuid_proficional") REFERENCES "proficional"("uuid_proficional") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamento_servico" ADD CONSTRAINT "agendamento_servico_uuid_servico_add_fkey" FOREIGN KEY ("uuid_servico_add") REFERENCES "servico_add"("uuid_servico_add") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamento_servico" ADD CONSTRAINT "agendamento_servico_uuid_agendamento_fkey" FOREIGN KEY ("uuid_agendamento") REFERENCES "agendamento"("uuid_agendamento") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagamento" ADD CONSTRAINT "pagamento_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "disponibilidade" ADD CONSTRAINT "disponibilidade_uuid_proficional_fkey" FOREIGN KEY ("uuid_proficional") REFERENCES "proficional"("uuid_proficional") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "disponibilidade" ADD CONSTRAINT "disponibilidade_uuid_agendamento_fkey" FOREIGN KEY ("uuid_agendamento") REFERENCES "agendamento"("uuid_agendamento") ON DELETE SET NULL ON UPDATE CASCADE;
