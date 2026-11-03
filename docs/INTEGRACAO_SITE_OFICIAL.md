# Integração controlada — Godot e site oficial
Atualizado em 2026-11-03. Este documento NÃO habilita publicação automática.

## Papéis
- **Código-fonte do jogo:** https://github.com/JorgeNovoJulho/DeiaNoveReinos
- **Site oficial e comunicação pública:** https://github.com/JorgeNovoJulho/Deia-Site-Oficial
- **Portal publicado:** https://jorgenovojulho.github.io/Deia-Site-Oficial/
- **Destino de demos no portal:** `demos/<nome-da-demo>/` (somente exportação Godot Web testada).
- O repositório do site não deve receber o projeto Godot completo, scripts internos, saves, arquivos privados, builds sem teste nem assets de fonte restrita.

## Estado comprovado na auditoria de 2026-11-03
Este repositório contém `project.godot`, `scenes/`, `scripts/`, `tests/` e `docs/PROGRESSO.md`; o progresso documenta as fases 01A–01E como implementadas e manualmente aprovadas. Há apenas ambientes geométricos de teste, não cenários finais. O projeto usa o recurso de compatibilidade GL e resolução inicial de 1280×720. A configuração atual não constitui comprovação de exportação Web funcional.

## Fluxo de publicação de versões
1. Desenvolver em branch do repositório do jogo, preservando a branch `main`.
2. Rodar testes GDScript, importar no Godot, testar manualmente a cena e guardar capturas/relatório.
3. Registrar versão, commit SHA, recursos incluídos e riscos em `docs/PROGRESSO.md`.
4. Em uma máquina/runner com Godot da mesma versão e templates de exportação, produzir build Web apenas se tecnicamente compatível, ou build desktop para distribuição alternativa.
5. Validar a exportação Web em servidor HTTP e navegador; testar teclado, assets, resolução, áudio, memória e erros.
6. Copiar SOMENTE arquivos estáticos exportados e homologados para `demos/<nome-da-demo>/` na branch de desenvolvimento do site; registrar origem no manifesto de publicação.
7. Abrir PR no site para aprovação. Publicar na `main` do site somente após homologação explícita.
8. Atualizar o diário e links públicos depois de verificar o deploy real.

## Consistência da narrativa e das artes
A `docs/Deia_e_os_Nove_Reinos_Magnificos_Biblia_Narrativa_v3.pdf` e `AGENTS.md` deste repositório não devem ser substituídos automaticamente pelo conteúdo `BIBLIA_MESTRA_V6_3.md` ou `content/lore.json` do site. Há versões distintas. Revisar diferenças e obter decisão do diretor criativo antes de declarar um cânone único.
A biblioteca de cards e cenários WebP no site é uma fonte de referências, NÃO necessariamente um pacote de sprites prontos para animação. Preservar identidades, créditos, licenças e arquivos originais.

## Transferência entre inteligências artificiais
Ao assumir a tarefa, ler `AGENTS.md`, `docs/PROGRESSO.md`, este documento, o `project.godot`, as cenas e testes pertinentes, e o documento recíproco no site. Ao terminar, relatar: branch, SHA, arquivos alterados, execução de testes, evidências visuais, limitações, decisões pendentes e próximo passo. Nunca relatar integração ou publicação como concluída sem confirmação.
