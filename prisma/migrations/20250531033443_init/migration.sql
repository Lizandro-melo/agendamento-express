-- CreateTable
CREATE TABLE "empresa_proficional" (
    "id" SERIAL NOT NULL,
    "uuid_empresa" TEXT NOT NULL,
    "uuid_proficional" TEXT NOT NULL,

    CONSTRAINT "empresa_proficional_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "empresa_proficional_id_key" ON "empresa_proficional"("id");

-- AddForeignKey
ALTER TABLE "empresa_proficional" ADD CONSTRAINT "empresa_proficional_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "empresa_proficional" ADD CONSTRAINT "empresa_proficional_uuid_proficional_fkey" FOREIGN KEY ("uuid_proficional") REFERENCES "proficional"("uuid_proficional") ON DELETE RESTRICT ON UPDATE CASCADE;
