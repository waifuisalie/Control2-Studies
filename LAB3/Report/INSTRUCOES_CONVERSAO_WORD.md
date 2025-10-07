# Instruções para Converter o Relatório para Word (Formato CBA/SBAI)

## 📄 Arquivo Fonte
`LAB3_Relatorio_Tecnico_Victor_Ramon.md`

## 🎯 Objetivo
Criar documento Word (.docx) com formatação profissional CBA/SBAI

---

## ✅ OPÇÃO 1: Pandoc (Recomendado - Automático)

### Passo 1: Instalar Pandoc
- Windows: Baixe em https://pandoc.org/installing.html
- Ou use: `choco install pandoc` (se tiver Chocolatey)

### Passo 2: Converter com Template
```bash
cd "Control2-Studies\LAB3\Report"

pandoc LAB3_Relatorio_Tecnico_Victor_Ramon.md -o LAB3_Relatorio_Tecnico_Victor_Ramon.docx \
  --reference-doc=template_cba_sbai.docx \
  --number-sections \
  --toc
```

### Passo 3: Ajustar Formatação Final no Word
1. Abrir o .docx gerado
2. Verificar espaçamento (1.5 linhas)
3. Ajustar margens (2.5 cm todas)
4. Revisar numeração de figuras
5. Inserir quebras de página se necessário

---

## ✅ OPÇÃO 2: Word Online (Microsoft 365) - Manual Rápido

### Passo 1: Abrir Word Online ou Word Desktop

### Passo 2: Configurar Página
- **Margens**: 2.5 cm (superior, inferior, esquerda, direita)
- **Fonte**: Times New Roman, 12pt
- **Espaçamento**: 1.5 linhas
- **Papel**: A4 (21 x 29.7 cm)

### Passo 3: Copiar e Colar Seções do .md

#### TÍTULO (Centralizado, Negrito, 14pt)
```
Identificação de Sistemas e Análise Crítica de Regras de Ajuste
de Controladores PID para Processos de Ordem Superior
```

#### AUTORES (Centralizado, 12pt)
```
Victor Henrique Alves Ribeiro, Ramon Gomes da Silva
```

#### AFILIAÇÃO (Centralizado, Itálico, 11pt)
```
Programa de Pós-Graduação em Engenharia de Produção e Sistemas (PPGEPS)
Pontifícia Universidade Católica do Paraná (PUCPR)
Rua Imaculada Conceição, 1155, CEP 80215-901, Curitiba, PR, Brasil
```

#### EMAILS (Centralizado, 10pt)
```
E-mail: victor.hribeiro@pucpr.br, ramon.gsilva@pucpr.br
```

### Passo 4: Adicionar Linha Horizontal (após emails)
Inserir > Formas > Linha Horizontal

### Passo 5: RESUMO
- **Título "RESUMO"**: Negrito, maiúsculas, alinhado à esquerda
- **Texto**: Justificado, 12pt
- **Palavras-chave**: Itálico

### Passo 6: Seções Numeradas (1, 2, 3...)
- **Títulos de Seção**: Negrito, 12pt, numerado (1. INTRODUÇÃO)
- **Subtítulos**: Negrito, 12pt, numerado (2.1. Modelo FOPDT)
- **Texto**: Justificado, 12pt, Times New Roman

### Passo 7: Equações
Use Editor de Equações do Word (Alt + =):

**Exemplo FOPDT:**
```
G(s) = (K·e^(-θs))/(Ts+1)
```

**Exemplo RMSE:**
```
RMSE = √(1/N Σ(yi - ŷi)²)
```

### Passo 8: Tabelas
- Inserir Tabela (menu Inserir)
- Estilo: Linhas de Grade Simples
- Centralizar tabela
- Negrito na primeira linha (cabeçalho)
- Adicionar legenda: "Tabela 1: Descrição..."

**Exemplo Tabela 1:**
| Método | K | T (s) | θ (s) | RMSE | IAE |
|--------|------|--------|--------|--------|--------|
| Gráfico (Smith) | 1.0000 | 1.1550 | 1.4100 | 0.0154 | 0.1106 |
| Toolbox (tfest) | 1.0209 | 2.2349 | 0.0000 | 0.1077 | 1.0647 |

### Passo 9: Figuras
1. Posicionar cursor onde diz "Figura X:"
2. Inserir > Imagens > Escolher arquivo:
   - **Figura 1**: `../lab3_implementation/M1_identification_results.png`
   - **Figura 2**: `../lab3_implementation/M2_identification_results.png`
   - **Figura 3**: `../lab3_implementation/error_metrics_comparison.png`
   - **Figura 4**: `../lab3_implementation/time_response_comparison.png`
   - **Figura 5**: `../lab3_implementation/metrics_comparison.png`
3. Redimensionar para largura = 16 cm (mantendo proporção)
4. Centralizar imagem
5. Adicionar legenda abaixo (Inserir > Legenda):
   - "Figura 1: Comparação dos modelos FOPDT para a planta M1..."

### Passo 10: Referências (ABNT)
- Alinhamento: Justificado
- Espaçamento: Simples (1.0)
- Recuo: 1.25 cm nas linhas subsequentes (exceto primeira)

**Formato ABNT:**
```
[1] SOBRENOME, Iniciais. Título. Edição. Cidade: Editora, Ano.

[2] SOBRENOME, Iniciais. Título do artigo. Nome da Revista, v. X, n. Y, p. ZZ-WW, ano.
```

---

## ✅ OPÇÃO 3: Google Docs (Grátis, Online)

1. Abrir Google Docs (docs.google.com)
2. Criar novo documento
3. Arquivo > Configurar Página:
   - Margens: 2.54 cm (todas)
   - Tamanho: A4
4. Seguir mesmas instruções da Opção 2
5. Ao final: Arquivo > Baixar > Microsoft Word (.docx)

---

## 📊 Checklist de Formatação (Rubrica - 10 pontos)

### ✅ Estrutura (1 ponto)
- [ ] Seções lógicas e numeradas (1, 2, 3...)
- [ ] Fluxo coerente: Intro → Teoria → Método → Resultados → Discussão → Conclusão

### ✅ Formatação (1 ponto)
- [ ] Padrão CBA/SBAI
- [ ] Times New Roman 12pt
- [ ] Espaçamento 1.5 linhas
- [ ] Margens 2.5 cm
- [ ] Máximo 6 páginas

### ✅ Introdução (1 ponto)
- [ ] Contextualização clara
- [ ] Objetivos definidos
- [ ] Justificativa do trabalho

### ✅ Apresentação dos Resultados (2 pontos)
- [ ] 5 figuras inseridas e legendadas
- [ ] 5 tabelas formatadas e legendadas
- [ ] Gráficos legíveis e profissionais

### ✅ Resultados (2 pontos)
- [ ] Dados numéricos corretos (das tabelas)
- [ ] Análise técnica completa
- [ ] Justificativa da seleção do modelo gráfico

### ✅ Conclusão (1 ponto)
- [ ] Síntese dos resultados
- [ ] Recomendações práticas
- [ ] Trabalhos futuros

### ✅ Referências Bibliográficas (1 ponto)
- [ ] 7 referências em ABNT
- [ ] Citações corretas no texto [1], [2]...
- [ ] Formatação adequada

### ✅ Avaliação Escrita (1 ponto)
- [ ] Redação técnica clara
- [ ] Sem erros de português
- [ ] Terminologia correta

---

## 🎨 Estilos de Formatação Rápida (Word)

### Criar Estilos Personalizados:

1. **Título Principal** (Ctrl + Alt + 1):
   - Times New Roman, 14pt, Negrito, Centralizado

2. **Título Seção** (Ctrl + Alt + 2):
   - Times New Roman, 12pt, Negrito, Numerado

3. **Subtítulo**:
   - Times New Roman, 12pt, Negrito, Numerado (ex: 2.1)

4. **Corpo de Texto**:
   - Times New Roman, 12pt, Justificado, Espaçamento 1.5

5. **Legenda de Figura/Tabela**:
   - Times New Roman, 11pt, Centralizado, Negrito ("Figura 1:"), Normal (descrição)

---

## 🔧 Atalhos Úteis do Word

- **Negrito**: Ctrl + B
- **Itálico**: Ctrl + I
- **Centralizar**: Ctrl + E
- **Justificar**: Ctrl + J
- **Inserir Equação**: Alt + =
- **Inserir Tabela**: Alt + N + T
- **Inserir Imagem**: Alt + N + P
- **Quebra de Página**: Ctrl + Enter

---

## 📁 Caminhos das Imagens

```
Figura 1: Control2-Studies\LAB3\lab3_implementation\M1_identification_results.png
Figura 2: Control2-Studies\LAB3\lab3_implementation\M2_identification_results.png
Figura 3: Control2-Studies\LAB3\lab3_implementation\error_metrics_comparison.png
Figura 4: Control2-Studies\LAB3\lab3_implementation\time_response_comparison.png
Figura 5: Control2-Studies\LAB3\lab3_implementation\metrics_comparison.png
```

---

## ⚠️ Atenção Final

1. **Revisar todas as equações** - Use Editor de Equações do Word
2. **Verificar numeração** - Figuras e tabelas devem estar sequenciais
3. **Conferir citações** - Todos os [1], [2]... devem ter entrada nas Referências
4. **Salvar como PDF** após finalizar para envio
5. **Nome do arquivo**: `LAB3_Relatorio_Tecnico_Victor_Ramon.pdf`

---

## ✅ Conversão Concluída!

Após seguir estas instruções, você terá um documento Word profissional, formatado no padrão CBA/SBAI, pronto para submissão!

**Meta: 10/10 pontos na rubrica de avaliação** 🎯
