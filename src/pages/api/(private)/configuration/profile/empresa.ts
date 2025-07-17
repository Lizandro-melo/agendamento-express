import { Register_empresa } from "@/backend/services/empresa/create";
import { Cadastro } from "@/types/empresa/req";
import type { NextApiRequest, NextApiResponse } from "next";




export default async function ProfileEmpresa(req: NextApiRequest, res: NextApiResponse) {
  res.status(200).json({ mensagem: "Acessado" })
}