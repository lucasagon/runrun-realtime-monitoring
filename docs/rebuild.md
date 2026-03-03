# Rebuild do Sistema

Procedimento para reconstrução completa:

1. TRUNCATE runrun_analytics.*
2. Reprocessar staging → analytics
3. Recriar snapshot
4. Validar contagem de eventos

Motivos para rebuild:

- Correção de bug
- Mudança de regra de negócio
- Ajuste de modelagem
- Validação de integridade