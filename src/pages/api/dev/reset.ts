
import PRISMA from "@/backend/services/db";
import { log } from "console";
import type { NextApiRequest, NextApiResponse } from "next";




export default async function reset(req: NextApiRequest, res: NextApiResponse) {
  try {
    await PRISMA.$transaction([
      PRISMA.user.deleteMany(),
      PRISMA.user_empresa.deleteMany(),
      PRISMA.empresa_proficional.deleteMany(),
      PRISMA.proficional.deleteMany(),
      PRISMA.pagamento.deleteMany(),
      PRISMA.empresa.deleteMany()
    ]);

    res.status(200).json({ mensagem: "Sucesso" })
  } catch (err: any) {
    res.status(400).json({ mensagem: err.message })
  }
}