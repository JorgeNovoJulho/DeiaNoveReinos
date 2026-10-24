# Progresso — Déia e os Nove Reinos Magníficos

## Fase 00 — Auditoria (concluída)

- Projeto Godot existente em `D:\Projetos\Deia_Nove_Reinos`, com Bíblia Narrativa V3.0 em `docs/`.
- Godot 4.7.2 estável disponível; projeto configurado para GL Compatibility.
- Git local na branch `main`, conectado ao repositório remoto, sem publicação.

## Fase 01A — Fundação (implementada; conferência visual pelo proprietário)

### Entregas

- Commit local inicial da configuração original: `3515b8d`. Nenhum push realizado.
- Resolução-base 1280 × 720 (16:9) e cena inicial no `project.godot`.
- Cena principal com sala de teste vertical e instância de Déia.
- Plataformas e aparência da personagem representadas por formas geométricas **provisórias**.
- `CharacterBody2D` com visual, colisão, controlador inicial e câmera filha. Sem movimento nesta etapa.
- Godot gerou `scripts/player/deia_controller.gd.uid` durante a importação, identificador nativo do script.
- Regras permanentes registradas em `AGENTS.md`.

### Testes

- Godot 4.7.2: importação/abertura do editor em modo headless (`--headless --editor --quit`): sucesso, código 0, sem erros relatados.
- Cena principal em execução headless por cinco quadros (`--headless --quit-after 5`): sucesso, código 0, sem erros relatados.
- Scripts e referências das cenas: carregados nas verificações acima sem erro de interpretação ou recurso ausente.
- O proprietário abriu o projeto e confirmou a cena com plataformas e a forma geométrica de Déia. Movimento ausente era esperado nesta etapa.
- Estes testes não aprovam a jogabilidade: a personagem ainda não se move.

### Problemas conhecidos e pendências

- Não há movimentação, HUD, combate, XP, santuário ou salvamento nesta fase.
- A aparência geométrica não é arte definitiva nem aprova a jogabilidade.
- Verificar visualmente a composição da sala e a câmera no editor.
- O arquivo `project.godot` conserva a opção de driver Windows `d3d12` já existente; o método de renderização ativo é `gl_compatibility`. A confirmação visual no Windows ainda está pendente.

### Próximo passo (somente com aprovação)

- Fase 01B foi aprovada e implementada abaixo.

## Fase 01B — Movimento básico (implementada; movimento confirmado pelo proprietário)

### Entregas

- Andar para esquerda/direita (`A`/`D` ou setas), salto (`Espaço`, `W` ou seta para cima), gravidade e colisão com piso/plataformas por `CharacterBody2D`.
- Câmera segue Déia com suavização, limitada às dimensões provisórias da sala de teste.
- Paredes laterais provisórias impedem sair horizontalmente da sala.
- Teste automático em `tests/smoke_01b.gd`; não há corrida, combate, magia, XP ou salvamento.

### Testes

- Godot 4.7.2, editor headless: importação sem erros, código 0.
- Teste headless da cena: ações de controle presentes; deslocamento para ambos os lados; salto; gravidade; retorno ao piso; pouso em plataforma; barreira lateral; câmera vinculada ao movimento vertical. Código 0.
- `git diff --check`: sem erros de espaço em branco (verificado ao fim da fase).
- Teste manual: o proprietário confirmou que a personagem se movimenta e salta. Alcance das plataformas, sensação do salto e conforto da câmera não foram avaliados especificamente no retorno; permanecem abertos a ajustes.

### Problemas conhecidos e pendências

- Movimento e cenário são provisórios. Não há animação ou indicação de controles na interface.
- Não há proteção para queda fora do cenário por cima/baixo além das paredes e piso de teste.
- Câmera e controles devem ser avaliados visualmente antes de ajustar velocidade/altura de salto.

### Próximo passo (somente com aprovação)

- Fase 01C foi aprovada e implementada abaixo.

## Fase 01C — Duas salas interligadas (implementada; funcionamento confirmado pelo proprietário)

### Entregas

- Segunda sala de teste geométrica com cor diferente, piso, paredes e plataformas provisórias.
- Passagem azul à direita da sala 1 leva à sala 2; passagem laranja à esquerda da sala 2 retorna à sala 1.
- Um controlador de transição troca somente a sala; Déia e sua câmera permanecem na cena principal.
- Marcadores de entrada posicionam Déia fora da área da passagem para não voltar automaticamente.
- Teste de regressão `tests/smoke_01c.gd` verifica ida, volta, posição de chegada e controles após a troca.
- Nenhum reino definitivo, salvamento, combate ou sistema global foi criado.

### Testes

- Editor Godot 4.7.2 em modo headless: importação e GDScript sem erros.
- Teste automatizado 01C: ida, volta, entradas e controle preservado: sucesso, código 0.
- Teste automatizado 01B repetido após as alterações: sucesso, código 0.
- Teste manual: o proprietário confirmou que a passagem entre salas funcionou e aprovou o resultado. Ajustes de conforto visual podem ser pedidos depois.

### Problemas encontrados e correções

- O primeiro teste 01C encontrou uma marcação de grupo inválida na cena da personagem. Corrigimos `groups=["player"]` no cabeçalho do nó; os testes de ida e volta passaram em seguida.

### Pendências

- Posições de chegada, continuidade da câmera e facilidade de encontrar as saídas podem receber ajustes futuros caso o proprietário identifique necessidade.
- As duas salas são apenas ambientes de teste, não reinos ou arte final.
- A Fase 01D foi aprovada e implementada abaixo.

## Fase 01D — HP/MP e alvo provisório (implementada; teste visual aprovado pelo proprietário)

### Entregas

- Componente `Vitals` de Déia com HP inicial 5/5 e MP inicial 3/3, sinais para atualização e limites de valor.
- HUD simples com indicadores de HP/MP no canto superior esquerdo, fixos na tela durante o movimento da câmera.
- Quadrado amarelo provisório na sala 1: o contato causa 1 ponto de dano ao entrar na área. Permanecer encostado não repete dano; sair e voltar conta como novo contato.
- HP/MP pertencem à instância persistente de Déia e não reiniciam ao trocar de sala.
- Teste automatizado `tests/smoke_01d.gd`. Nenhum ataque, arma, magia, XP, nível ou salvamento foi implementado.

### Testes

- Editor Godot 4.7.2 headless: importação dos scripts e cenas sem erro, código 0.
- Teste 01D headless: HP/MP iniciais, dano único por contato, novo dano após reentrada, indicadores atualizados, limites de HP/MP e preservação do HP ao entrar na sala 2: sucesso, código 0.
- Testes de regressão 01B e 01C: sucesso, código 0.
- Teste visual: o proprietário confirmou que tudo funcionou e aprovou o resultado da Fase 01D. Os testes automáticos detalhados estão registrados acima.

### Problemas conhecidos e pendências

- O alvo é somente um obstáculo de contato provisório; não recebe ataques nesta fase.
- MP ainda não é consumido durante a jogabilidade porque não há magias. Suas operações foram testadas automaticamente.
- Não há reação visual ao dano, invulnerabilidade temporária, derrota, restauração em santuário ou persistência em disco.
- Fase 01E foi autorizada e implementada abaixo.

## Fase 01E — Santuário e salvamento mínimos (implementada; teste visual confirmado pelo proprietário)

### Entregas

- Santuário verde-água provisório na sala 1; estando perto dele, pressionar `E` restaura completamente HP e MP e salva.
- Save local único em `user://deia_slot_1.json`, não dentro da pasta do projeto; ao abrir o jogo, Déia retoma na sala 1, no ponto seguro (520, 644), com os valores salvos.
- Gerenciador local como nó filho da cena principal, sem autoload ou plugin. Validação de versão, sala, ponto seguro e limites de HP/MP; arquivo ausente/inválido inicia normalmente sem carregar.
- Teste automático `tests/smoke_01e.gd` usa um arquivo exclusivo temporário em `user://` e remove apenas o que criou; os testes anteriores não carregam o save real.

### Testes

- Godot 4.7.2, importação pelo editor headless: sucesso.
- Teste 01E: tecla de interação, recuperação de HP/MP, criação do save local, leitura do ponto seguro, retomada ao criar nova instância e rejeição de JSON inválido: sucesso, código 0. O aviso sobre JSON inválido foi intencional no teste.
- Regressões 01B, 01C e 01D: sucesso, códigos 0. Cena principal executada headless por cinco quadros: sucesso, código 0.
- Teste manual: o proprietário confirmou que o fluxo do santuário e salvamento funcionou. A Fase 01E está aceita.

### Limitações e pendências

- Apenas um slot de teste. Não existem autosave, checkpoints de morte, sonhos, reaparição de inimigos, XP ou progressão permanente.
- O save registra somente sala/ponto seguro e HP/MP; após descanso esses valores são máximos. Não registra a posição de cada passo ou estado temporário de salas.
- A escrita é simples e validada na leitura; cópia de segurança/migração de versões fica para uma etapa futura.
- A aprovação da experiência visual depende do teste manual do proprietário. Não avançar para outra fase sem autorização explícita.
