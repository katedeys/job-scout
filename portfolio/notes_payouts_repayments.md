# Case 4 · Disbursements and repayments (SkyRo, Malaysia) — raw notes from Kate

## Disbursements
- Destination by customer choice; mostly bank transfer via FPX.
- Primary and backup payout partner.
- Built from scratch (nothing before).
- Retries until timeout with a time ladder (backoff); customer learns the result by our push.
- Reconciliation via partner API.

## Repayments
- 2 partners, 3 methods each: cards via PSPs, bank transfers via Virtual IBANs, cash.
- Cash: various networks, through a QR code shown in our app.
- Cards: one-off and auto-debit.
- Each payment is linked to the loan contract at initiation.
- Success AND failure events go to Kafka.
- Full payoff amount: logic lives in the credit engine (async, revalidated before execution — from CV).

## Consumers of the Kafka payment events
- Credit engine, DWH, origination.

## From CV
- Async disbursements with callbacks, status checks, idempotency, retries and reconciliation removed manual payout investigations entirely.
- Monitoring and alerting requirements for the credit payouts rollout.
