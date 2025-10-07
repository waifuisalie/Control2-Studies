# 📄 Gerador de Template CBA/SBAI

## 🎯 Objetivo

Este script cria automaticamente um arquivo Word (`template_cba_sbai.docx`) formatado no padrão CBA/SBAI para uso com Pandoc.

## 🚀 Como Usar

### Passo 1: Rodar o Script

Abra o terminal/CMD nesta pasta e execute:

```cmd
python generate_template.py
```

**O que acontece:**
- ✅ Verifica se `python-docx` está instalado
- ✅ Se não estiver, instala automaticamente
- ✅ Cria arquivo `template_cba_sbai.docx` com formatação CBA/SBAI

**Saída esperada:**
```
📦 Instalando biblioteca python-docx... (se necessário)
🎨 Criando template CBA/SBAI...
✅ Template criado com sucesso: template_cba_sbai.docx

📋 Configurações do template:
   - Margens: 2.5 cm (todas)
   - Fonte: Times New Roman 12pt
   - Espaçamento: 1.5 linhas
   - Tamanho: A4

🚀 Agora você pode usar:
   pandoc arquivo.md -o saida.docx --reference-doc=template_cba_sbai.docx --number-sections
```

### Passo 2: Converter o Relatório

Depois de gerar o template, use-o para converter o Markdown:

```cmd
pandoc LAB3_Relatorio_Tecnico_Victor_Ramon.md -o LAB3_Relatorio_Tecnico_Victor_Ramon.docx --reference-doc=template_cba_sbai.docx --number-sections
```

## 📋 Requisitos

- **Python 3.6+** (verificar com `python --version`)
- **Biblioteca python-docx** (instalada automaticamente pelo script)
- **Pandoc** (para conversão Markdown → Word)

### Verificar se Python está instalado:

```cmd
python --version
```

Se não tiver Python:
- **Windows:** Baixe em https://www.python.org/downloads/
- Durante instalação, marque: ✅ "Add Python to PATH"

### Verificar se Pandoc está instalado:

```cmd
pandoc --version
```

Se não tiver Pandoc:
- **Windows:** Baixe em https://pandoc.org/installing.html
- Ou use: `choco install pandoc` (se tiver Chocolatey)

## 🎨 O que o Template Contém

O template gerado possui os seguintes estilos formatados:

| Estilo | Formatação |
|--------|------------|
| **Title** | Times New Roman 14pt, Negrito, Centralizado |
| **Subtitle** | Times New Roman 12pt, Negrito, Centralizado |
| **Affiliation** | Times New Roman 11pt, Itálico, Centralizado |
| **Heading 1** | Times New Roman 12pt, Negrito, Maiúsculas, Numerado |
| **Heading 2** | Times New Roman 12pt, Negrito, Numerado |
| **Heading 3** | Times New Roman 12pt, Negrito Itálico |
| **Normal** | Times New Roman 12pt, Justificado, Espaçamento 1.5 |
| **Caption** | Times New Roman 11pt, Centralizado |

**Configuração de Página:**
- Margens: 2.5 cm (superior, inferior, esquerda, direita)
- Papel: A4 (21 cm × 29.7 cm)

## 🔧 Solução de Problemas

### Erro: "python não é reconhecido..."

**Solução:** Python não está no PATH.
- Reinstale Python e marque "Add to PATH"
- Ou use caminho completo: `C:\Python39\python.exe generate_template.py`

### Erro: "No module named 'docx'"

**Solução:** Instale manualmente:
```cmd
pip install python-docx
```

### Erro: "pandoc não é reconhecido..."

**Solução:** Pandoc não está instalado.
- Baixe em: https://pandoc.org/installing.html
- Adicione ao PATH do Windows

### Template gerado mas conversão Pandoc falha

**Solução:** Use comando em uma linha (Windows CMD não aceita `\`):

```cmd
pandoc LAB3_Relatorio_Tecnico_Victor_Ramon.md -o LAB3_Relatorio_Tecnico_Victor_Ramon.docx --reference-doc=template_cba_sbai.docx --number-sections
```

## 📚 Exemplo de Uso Completo

```cmd
# 1. Navegar até a pasta
cd "C:\Users\Francisco\OneDrive - Grupo Marista\Desktop\2025-02\Controle\Lab 3 Final\Control2-Studies\LAB3\Report"

# 2. Gerar template
python generate_template.py

# 3. Converter Markdown para Word usando o template
pandoc LAB3_Relatorio_Tecnico_Victor_Ramon.md -o LAB3_Relatorio_Tecnico_Victor_Ramon.docx --reference-doc=template_cba_sbai.docx --number-sections

# 4. Abrir documento gerado
start LAB3_Relatorio_Tecnico_Victor_Ramon.docx
```

## ✅ Resultado Esperado

Após executar os comandos acima, você terá:

1. ✅ `template_cba_sbai.docx` → Template formatado
2. ✅ `LAB3_Relatorio_Tecnico_Victor_Ramon.docx` → Relatório convertido e formatado

## 🔄 Ajustes Finais no Word

Depois da conversão, abra o `.docx` e ajuste:

1. **Inserir Figuras:**
   - Posicionar em cada "Figura X:"
   - Inserir > Imagens > Escolher arquivo
   - Redimensionar para ~16 cm largura

2. **Formatar Equações:**
   - Usar Editor de Equações (Alt + =)
   - Converter notação LaTeX para formato Word

3. **Revisar Tabelas:**
   - Verificar alinhamento
   - Centralizar tabelas

4. **Verificar Numeração:**
   - Seções, figuras e tabelas devem estar sequenciais

## 📝 Notas

- O script cria um template **genérico** CBA/SBAI
- Pode ser reutilizado para outros trabalhos
- Compatível com Pandoc 2.0+
- Testado em Windows 10/11

## 🆘 Suporte

Se encontrar problemas:
1. Verifique se Python e Pandoc estão instalados
2. Execute os comandos em ordem
3. Use CMD (não PowerShell) para evitar problemas com caracteres especiais

---

**Criado por:** Claude Code
**Versão:** 1.0
**Data:** 2025
