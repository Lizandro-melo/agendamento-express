import { Register_empresa } from "@/backend/services/empresa/create";
import { Cadastro } from "@/types/empresa/req";
import type { NextApiRequest, NextApiResponse } from "next";




export default async function Register(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === "POST") {
    const { empresa, proficional, valor }: Cadastro = req.body;
    try {
      await new Register_empresa({ empresa, proficional, valor }).Registrar()
      res.status(200).json({ mensagem: "Empresa cadastrada com sucesso" });
    } catch (error: any) {
      res.status(400).send({ mensagem: error.message })
    }
  } else {
    res.status(405).json({ mensagem: "Metodo invalido" });
  }
}
