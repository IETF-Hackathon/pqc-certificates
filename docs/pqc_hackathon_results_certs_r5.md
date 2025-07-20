
IETF PQC Hackathon Certificate Interoperability Results
=======================================================


<style> table { border-collapse: collapse; width:auto !important; } th, td { border: solid black 1px; padding: 0 1ex; } col { width: auto !important; } </style>

Generated: 2025-07-20 11:18 UTC


# Algorithms Submitted


✅ = passing all verifiers<br>◒ = passing some verifiers<br>⚪︎ = not passing any verifiers<br>Columns represent producers who submitted artifacts. Verifiers are not listed in this table, but are listed in the broken-out tables below.<br>


|-|bc|carl-redhound|cht|composite-kem-ref-impl|composite-ref-impl|composite-sigs-ref-impl|corey-digicert|crypto4a|cryptonext|entrust|ossl35|safelogic|seventhsense.ai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|[Falcon-1024-cert](#Falcon-1024-cert)|✅ 1/1||||||||✅ 1/1|✅ 1/1||||
|[Falcon-1024-consistent](#Falcon-1024-consistent)|⚪︎ 0/1||||||||✅ 1/1|⚪︎ 0/1||||
|[Falcon-1024-priv](#Falcon-1024-priv)|⚪︎ 0/1||||||||✅ 1/1|⚪︎ 0/1||||
|[ML-DSA-44-both](#ML-DSA-44-both)|✅ 5/5|✅ 6/6|✅ 3/3||||✅ 6/6|✅ 6/6|✅ 6/6||✅ 6/6|✅ 2/2|◒ 1/2|
|[ML-DSA-44-cert](#ML-DSA-44-cert)|✅ 5/5|✅ 5/5|✅ 2/2||✅ 1/1|✅ 1/1|✅ 5/5|✅ 5/5|◒ 4/5|◒ 4/5|✅ 5/5|✅ 2/2|✅ 1/1|
|[ML-DSA-44-consistent](#ML-DSA-44-consistent)|✅ 4/4|✅ 4/4|✅ 1/1|||✅ 1/1|✅ 4/4|✅ 4/4|✅ 4/4|◒ 1/2|✅ 4/4|✅ 2/2|✅ 1/1|
|[ML-DSA-44-expandedkey](#ML-DSA-44-expandedkey)|✅ 6/6|✅ 6/6|✅ 3/3||||✅ 6/6||✅ 6/6|◒ 2/6|✅ 6/6|✅ 3/3|◒ 1/2|
|[ML-DSA-44-priv](#ML-DSA-44-priv)||||||✅ 2/2||||||||
|[ML-DSA-44-seed](#ML-DSA-44-seed)|✅ 6/6|✅ 6/6|✅ 3/3||||✅ 6/6||✅ 6/6||✅ 6/6|✅ 2/2|◒ 1/2|
|[ML-DSA-65-both](#ML-DSA-65-both)|✅ 5/5|✅ 6/6|✅ 3/3||||✅ 6/6|✅ 6/6|✅ 6/6||✅ 6/6|✅ 2/2|◒ 1/2|
|[ML-DSA-65-cert](#ML-DSA-65-cert)|✅ 5/5|✅ 5/5|✅ 2/2|||✅ 1/1|✅ 5/5|✅ 5/5|◒ 4/5|◒ 4/5|✅ 5/5|✅ 2/2|✅ 1/1|
|[ML-DSA-65-consistent](#ML-DSA-65-consistent)|✅ 4/4|✅ 4/4|✅ 1/1|||✅ 1/1|✅ 4/4|✅ 4/4|✅ 4/4|◒ 1/2|✅ 4/4|✅ 2/2|✅ 1/1|
|[ML-DSA-65-expandedkey](#ML-DSA-65-expandedkey)|✅ 6/6|✅ 6/6|✅ 3/3||||✅ 6/6||✅ 6/6|◒ 2/6|✅ 6/6|✅ 3/3|◒ 1/2|
|[ML-DSA-65-priv](#ML-DSA-65-priv)||||||✅ 2/2||||||||
|[ML-DSA-65-seed](#ML-DSA-65-seed)|✅ 6/6|✅ 6/6|✅ 3/3||||✅ 6/6||✅ 6/6||✅ 6/6|✅ 2/2|◒ 1/2|
|[ML-DSA-87-both](#ML-DSA-87-both)|✅ 5/5|✅ 6/6|✅ 3/3||||✅ 6/6|✅ 6/6|✅ 6/6||✅ 6/6|✅ 2/2|◒ 1/2|
|[ML-DSA-87-cert](#ML-DSA-87-cert)|✅ 5/5|✅ 5/5|✅ 2/2|||✅ 1/1|✅ 5/5|✅ 5/5|◒ 4/5|◒ 4/5|✅ 5/5|✅ 2/2|✅ 1/1|
|[ML-DSA-87-consistent](#ML-DSA-87-consistent)|✅ 4/4|✅ 4/4|✅ 1/1|||✅ 1/1|✅ 4/4|✅ 4/4|✅ 4/4|◒ 1/2|✅ 4/4|✅ 2/2|✅ 1/1|
|[ML-DSA-87-expandedkey](#ML-DSA-87-expandedkey)|✅ 6/6|✅ 6/6|✅ 3/3||||✅ 6/6||✅ 6/6|✅ 1/1|✅ 6/6|✅ 3/3|◒ 1/2|
|[ML-DSA-87-priv](#ML-DSA-87-priv)||||||✅ 2/2||||◒ 1/3||||
|[ML-DSA-87-seed](#ML-DSA-87-seed)|✅ 6/6|✅ 6/6|✅ 3/3||||✅ 6/6||✅ 6/6||✅ 6/6|✅ 2/2|◒ 1/2|
|[SLH-DSA-SHA2-128s-both](#SLH-DSA-SHA2-128s-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-128s-cert](#SLH-DSA-SHA2-128s-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHA2-128s-consistent](#SLH-DSA-SHA2-128s-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHA2-128s-expandedkey](#SLH-DSA-SHA2-128s-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-128s-priv](#SLH-DSA-SHA2-128s-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHA2-128s-seed](#SLH-DSA-SHA2-128s-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-128f-both](#SLH-DSA-SHA2-128f-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-128f-cert](#SLH-DSA-SHA2-128f-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHA2-128f-consistent](#SLH-DSA-SHA2-128f-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHA2-128f-expandedkey](#SLH-DSA-SHA2-128f-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-128f-priv](#SLH-DSA-SHA2-128f-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHA2-128f-seed](#SLH-DSA-SHA2-128f-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-192s-both](#SLH-DSA-SHA2-192s-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-192s-cert](#SLH-DSA-SHA2-192s-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHA2-192s-consistent](#SLH-DSA-SHA2-192s-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHA2-192s-expandedkey](#SLH-DSA-SHA2-192s-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-192s-priv](#SLH-DSA-SHA2-192s-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHA2-192s-seed](#SLH-DSA-SHA2-192s-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-192f-both](#SLH-DSA-SHA2-192f-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-192f-cert](#SLH-DSA-SHA2-192f-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHA2-192f-consistent](#SLH-DSA-SHA2-192f-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHA2-192f-expandedkey](#SLH-DSA-SHA2-192f-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-192f-priv](#SLH-DSA-SHA2-192f-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHA2-192f-seed](#SLH-DSA-SHA2-192f-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-256s-both](#SLH-DSA-SHA2-256s-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-256s-cert](#SLH-DSA-SHA2-256s-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHA2-256s-consistent](#SLH-DSA-SHA2-256s-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHA2-256s-expandedkey](#SLH-DSA-SHA2-256s-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-256s-priv](#SLH-DSA-SHA2-256s-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHA2-256s-seed](#SLH-DSA-SHA2-256s-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-256f-both](#SLH-DSA-SHA2-256f-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-256f-cert](#SLH-DSA-SHA2-256f-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHA2-256f-consistent](#SLH-DSA-SHA2-256f-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHA2-256f-expandedkey](#SLH-DSA-SHA2-256f-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHA2-256f-priv](#SLH-DSA-SHA2-256f-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHA2-256f-seed](#SLH-DSA-SHA2-256f-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-128s-both](#SLH-DSA-SHAKE-128s-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-128s-cert](#SLH-DSA-SHAKE-128s-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHAKE-128s-consistent](#SLH-DSA-SHAKE-128s-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHAKE-128s-expandedkey](#SLH-DSA-SHAKE-128s-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-128s-priv](#SLH-DSA-SHAKE-128s-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHAKE-128s-seed](#SLH-DSA-SHAKE-128s-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-128f-both](#SLH-DSA-SHAKE-128f-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-128f-cert](#SLH-DSA-SHAKE-128f-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHAKE-128f-consistent](#SLH-DSA-SHAKE-128f-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHAKE-128f-expandedkey](#SLH-DSA-SHAKE-128f-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-128f-priv](#SLH-DSA-SHAKE-128f-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHAKE-128f-seed](#SLH-DSA-SHAKE-128f-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-192s-both](#SLH-DSA-SHAKE-192s-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-192s-cert](#SLH-DSA-SHAKE-192s-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHAKE-192s-consistent](#SLH-DSA-SHAKE-192s-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHAKE-192s-expandedkey](#SLH-DSA-SHAKE-192s-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-192s-priv](#SLH-DSA-SHAKE-192s-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHAKE-192s-seed](#SLH-DSA-SHAKE-192s-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-192f-both](#SLH-DSA-SHAKE-192f-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-192f-cert](#SLH-DSA-SHAKE-192f-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHAKE-192f-consistent](#SLH-DSA-SHAKE-192f-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHAKE-192f-expandedkey](#SLH-DSA-SHAKE-192f-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-192f-priv](#SLH-DSA-SHAKE-192f-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHAKE-192f-seed](#SLH-DSA-SHAKE-192f-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-256s-both](#SLH-DSA-SHAKE-256s-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-256s-cert](#SLH-DSA-SHAKE-256s-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHAKE-256s-consistent](#SLH-DSA-SHAKE-256s-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHAKE-256s-expandedkey](#SLH-DSA-SHAKE-256s-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-256s-priv](#SLH-DSA-SHAKE-256s-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHAKE-256s-seed](#SLH-DSA-SHAKE-256s-seed)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-256f-both](#SLH-DSA-SHAKE-256f-both)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-256f-cert](#SLH-DSA-SHAKE-256f-cert)|✅ 4/4|✅ 4/4|✅ 2/2|||||✅ 1/1|✅ 4/4||✅ 4/4||✅ 1/1|
|[SLH-DSA-SHAKE-256f-consistent](#SLH-DSA-SHAKE-256f-consistent)|✅ 3/3|✅ 3/3|✅ 1/1|||||✅ 1/1|✅ 3/3||✅ 3/3||✅ 1/1|
|[SLH-DSA-SHAKE-256f-expandedkey](#SLH-DSA-SHAKE-256f-expandedkey)|||||||||||||✅ 2/2|
|[SLH-DSA-SHAKE-256f-priv](#SLH-DSA-SHAKE-256f-priv)|✅ 5/5|✅ 5/5|✅ 3/3|||||✅ 2/2|✅ 5/5||✅ 5/5|||
|[SLH-DSA-SHAKE-256f-seed](#SLH-DSA-SHAKE-256f-seed)|||||||||||||✅ 2/2|
|[HASH-ML-DSA-44-both](#HASH-ML-DSA-44-both)|✅ 3/3||✅ 3/3||||✅ 2/2|✅ 2/2|✅ 1/1||||⚪︎ 0/2|
|[HASH-ML-DSA-44-cert](#HASH-ML-DSA-44-cert)|✅ 2/2||✅ 2/2||||✅ 2/2|✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-ML-DSA-44-consistent](#HASH-ML-DSA-44-consistent)|✅ 1/1||✅ 1/1||||✅ 1/1|✅ 1/1|✅ 1/1||||⚪︎ 0/1|
|[HASH-ML-DSA-44-expandedkey](#HASH-ML-DSA-44-expandedkey)|✅ 3/3||✅ 3/3||||✅ 2/2||✅ 3/3||||⚪︎ 0/2|
|[HASH-ML-DSA-44-seed](#HASH-ML-DSA-44-seed)|✅ 3/3||✅ 3/3||||✅ 2/2||✅ 1/1||||⚪︎ 0/2|
|[HASH-ML-DSA-65-both](#HASH-ML-DSA-65-both)|✅ 3/3||✅ 3/3||||✅ 3/3|✅ 2/2|✅ 1/1||||⚪︎ 0/2|
|[HASH-ML-DSA-65-cert](#HASH-ML-DSA-65-cert)|✅ 2/2||✅ 2/2||||✅ 2/2|✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-ML-DSA-65-consistent](#HASH-ML-DSA-65-consistent)|✅ 1/1||✅ 1/1||||✅ 1/1|✅ 1/1|✅ 1/1||||⚪︎ 0/1|
|[HASH-ML-DSA-65-expandedkey](#HASH-ML-DSA-65-expandedkey)|✅ 3/3||✅ 3/3||||✅ 3/3||✅ 3/3||||⚪︎ 0/2|
|[HASH-ML-DSA-65-seed](#HASH-ML-DSA-65-seed)|✅ 3/3||✅ 3/3||||✅ 3/3||✅ 1/1||||⚪︎ 0/2|
|[HASH-ML-DSA-87-both](#HASH-ML-DSA-87-both)|✅ 3/3||✅ 3/3||||✅ 2/2|✅ 2/2|✅ 1/1||||⚪︎ 0/2|
|[HASH-ML-DSA-87-cert](#HASH-ML-DSA-87-cert)|✅ 2/2||✅ 2/2||||✅ 2/2|✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-ML-DSA-87-consistent](#HASH-ML-DSA-87-consistent)|✅ 1/1||✅ 1/1||||✅ 1/1|✅ 1/1|✅ 1/1||||⚪︎ 0/1|
|[HASH-ML-DSA-87-expandedkey](#HASH-ML-DSA-87-expandedkey)|✅ 3/3||✅ 3/3||||✅ 2/2||✅ 3/3||||⚪︎ 0/2|
|[HASH-ML-DSA-87-seed](#HASH-ML-DSA-87-seed)|✅ 3/3||✅ 3/3||||✅ 2/2||✅ 1/1||||⚪︎ 0/2|
|[HASH-SLH-DSA-SHA2-128s-both](#HASH-SLH-DSA-SHA2-128s-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-128s-cert](#HASH-SLH-DSA-SHA2-128s-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-128s-consistent](#HASH-SLH-DSA-SHA2-128s-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-128s-expandedkey](#HASH-SLH-DSA-SHA2-128s-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-128s-priv](#HASH-SLH-DSA-SHA2-128s-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHA2-128s-seed](#HASH-SLH-DSA-SHA2-128s-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-128f-both](#HASH-SLH-DSA-SHA2-128f-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-128f-cert](#HASH-SLH-DSA-SHA2-128f-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-128f-consistent](#HASH-SLH-DSA-SHA2-128f-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-128f-expandedkey](#HASH-SLH-DSA-SHA2-128f-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-128f-priv](#HASH-SLH-DSA-SHA2-128f-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHA2-128f-seed](#HASH-SLH-DSA-SHA2-128f-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-192s-both](#HASH-SLH-DSA-SHA2-192s-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-192s-cert](#HASH-SLH-DSA-SHA2-192s-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-192s-consistent](#HASH-SLH-DSA-SHA2-192s-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-192s-expandedkey](#HASH-SLH-DSA-SHA2-192s-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-192s-priv](#HASH-SLH-DSA-SHA2-192s-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHA2-192s-seed](#HASH-SLH-DSA-SHA2-192s-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-192f-both](#HASH-SLH-DSA-SHA2-192f-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-192f-cert](#HASH-SLH-DSA-SHA2-192f-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-192f-consistent](#HASH-SLH-DSA-SHA2-192f-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-192f-expandedkey](#HASH-SLH-DSA-SHA2-192f-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-192f-priv](#HASH-SLH-DSA-SHA2-192f-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHA2-192f-seed](#HASH-SLH-DSA-SHA2-192f-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-256s-both](#HASH-SLH-DSA-SHA2-256s-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-256s-cert](#HASH-SLH-DSA-SHA2-256s-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-256s-consistent](#HASH-SLH-DSA-SHA2-256s-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-256s-expandedkey](#HASH-SLH-DSA-SHA2-256s-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-256s-priv](#HASH-SLH-DSA-SHA2-256s-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHA2-256s-seed](#HASH-SLH-DSA-SHA2-256s-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-256f-both](#HASH-SLH-DSA-SHA2-256f-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-256f-cert](#HASH-SLH-DSA-SHA2-256f-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-256f-consistent](#HASH-SLH-DSA-SHA2-256f-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHA2-256f-expandedkey](#HASH-SLH-DSA-SHA2-256f-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHA2-256f-priv](#HASH-SLH-DSA-SHA2-256f-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHA2-256f-seed](#HASH-SLH-DSA-SHA2-256f-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-128s-both](#HASH-SLH-DSA-SHAKE-128s-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-128s-cert](#HASH-SLH-DSA-SHAKE-128s-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-128s-consistent](#HASH-SLH-DSA-SHAKE-128s-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-128s-expandedkey](#HASH-SLH-DSA-SHAKE-128s-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-128s-priv](#HASH-SLH-DSA-SHAKE-128s-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHAKE-128s-seed](#HASH-SLH-DSA-SHAKE-128s-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-128f-both](#HASH-SLH-DSA-SHAKE-128f-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-128f-cert](#HASH-SLH-DSA-SHAKE-128f-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-128f-consistent](#HASH-SLH-DSA-SHAKE-128f-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-128f-expandedkey](#HASH-SLH-DSA-SHAKE-128f-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-128f-priv](#HASH-SLH-DSA-SHAKE-128f-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHAKE-128f-seed](#HASH-SLH-DSA-SHAKE-128f-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-192s-both](#HASH-SLH-DSA-SHAKE-192s-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-192s-cert](#HASH-SLH-DSA-SHAKE-192s-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-192s-consistent](#HASH-SLH-DSA-SHAKE-192s-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-192s-expandedkey](#HASH-SLH-DSA-SHAKE-192s-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-192s-priv](#HASH-SLH-DSA-SHAKE-192s-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHAKE-192s-seed](#HASH-SLH-DSA-SHAKE-192s-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-192f-both](#HASH-SLH-DSA-SHAKE-192f-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-192f-cert](#HASH-SLH-DSA-SHAKE-192f-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-192f-consistent](#HASH-SLH-DSA-SHAKE-192f-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-192f-expandedkey](#HASH-SLH-DSA-SHAKE-192f-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-192f-priv](#HASH-SLH-DSA-SHAKE-192f-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHAKE-192f-seed](#HASH-SLH-DSA-SHAKE-192f-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-256s-both](#HASH-SLH-DSA-SHAKE-256s-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-256s-cert](#HASH-SLH-DSA-SHAKE-256s-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-256s-consistent](#HASH-SLH-DSA-SHAKE-256s-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-256s-expandedkey](#HASH-SLH-DSA-SHAKE-256s-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-256s-priv](#HASH-SLH-DSA-SHAKE-256s-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHAKE-256s-seed](#HASH-SLH-DSA-SHAKE-256s-seed)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-256f-both](#HASH-SLH-DSA-SHAKE-256f-both)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-256f-cert](#HASH-SLH-DSA-SHAKE-256f-cert)|✅ 2/2||✅ 2/2|||||✅ 1/1|✅ 2/2||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-256f-consistent](#HASH-SLH-DSA-SHAKE-256f-consistent)|✅ 1/1||✅ 1/1|||||✅ 1/1|✅ 1/1||||✅ 1/1|
|[HASH-SLH-DSA-SHAKE-256f-expandedkey](#HASH-SLH-DSA-SHAKE-256f-expandedkey)|||||||||||||✅ 2/2|
|[HASH-SLH-DSA-SHAKE-256f-priv](#HASH-SLH-DSA-SHAKE-256f-priv)|✅ 3/3||✅ 3/3|||||✅ 2/2|✅ 3/3|||||
|[HASH-SLH-DSA-SHAKE-256f-seed](#HASH-SLH-DSA-SHAKE-256f-seed)|||||||||||||✅ 2/2|
|[ML-KEM-512-both](#ML-KEM-512-both)|✅ 3/3||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-512-cert](#ML-KEM-512-cert)|✅ 4/4||✅ 2/2||||||✅ 4/4||✅ 4/4||✅ 1/1|
|[ML-KEM-512-consistent](#ML-KEM-512-consistent)|✅ 3/3||✅ 1/1||||||✅ 3/3||✅ 3/3||✅ 1/1|
|[ML-KEM-512-expandedkey](#ML-KEM-512-expandedkey)|✅ 4/4||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-512-priv](#ML-KEM-512-priv)|||||||||||||⚪︎ 0/1|
|[ML-KEM-512-seed](#ML-KEM-512-seed)|✅ 4/4||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-768-both](#ML-KEM-768-both)|✅ 3/3||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-768-cert](#ML-KEM-768-cert)|✅ 4/4||✅ 2/2|✅ 1/1|||||✅ 4/4||✅ 4/4||✅ 1/1|
|[ML-KEM-768-consistent](#ML-KEM-768-consistent)|✅ 3/3||✅ 1/1|✅ 1/1|||||✅ 3/3||✅ 3/3||✅ 1/1|
|[ML-KEM-768-expandedkey](#ML-KEM-768-expandedkey)|✅ 4/4||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-768-priv](#ML-KEM-768-priv)||||✅ 1/1|||||||||⚪︎ 0/1|
|[ML-KEM-768-seed](#ML-KEM-768-seed)|✅ 4/4||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-1024-both](#ML-KEM-1024-both)|✅ 3/3||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-1024-cert](#ML-KEM-1024-cert)|✅ 4/4||✅ 2/2|✅ 1/1|||||✅ 4/4||✅ 4/4||✅ 1/1|
|[ML-KEM-1024-consistent](#ML-KEM-1024-consistent)|✅ 3/3||✅ 1/1|✅ 1/1|||||✅ 3/3||✅ 3/3||✅ 1/1|
|[ML-KEM-1024-expandedkey](#ML-KEM-1024-expandedkey)|✅ 4/4||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[ML-KEM-1024-priv](#ML-KEM-1024-priv)||||✅ 1/1|||||||||⚪︎ 0/1|
|[ML-KEM-1024-seed](#ML-KEM-1024-seed)|✅ 4/4||◒ 1/2||||||✅ 4/4||✅ 4/4|||
|[id-MLKEM768-RSA2048-HMAC-SHA256-cert](#id-MLKEM768-RSA2048-HMAC-SHA256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA2048-HMAC-SHA256-consistent](#id-MLKEM768-RSA2048-HMAC-SHA256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA2048-HMAC-SHA256-priv](#id-MLKEM768-RSA2048-HMAC-SHA256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA3072-HMAC-SHA256-cert](#id-MLKEM768-RSA3072-HMAC-SHA256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA3072-HMAC-SHA256-consistent](#id-MLKEM768-RSA3072-HMAC-SHA256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA3072-HMAC-SHA256-priv](#id-MLKEM768-RSA3072-HMAC-SHA256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA4096-HMAC-SHA256-cert](#id-MLKEM768-RSA4096-HMAC-SHA256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA4096-HMAC-SHA256-consistent](#id-MLKEM768-RSA4096-HMAC-SHA256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-RSA4096-HMAC-SHA256-priv](#id-MLKEM768-RSA4096-HMAC-SHA256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-X25519-SHA3-256-cert](#id-MLKEM768-X25519-SHA3-256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-X25519-SHA3-256-consistent](#id-MLKEM768-X25519-SHA3-256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-X25519-SHA3-256-priv](#id-MLKEM768-X25519-SHA3-256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-P256-HMAC-SHA256-cert](#id-MLKEM768-ECDH-P256-HMAC-SHA256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-P256-HMAC-SHA256-consistent](#id-MLKEM768-ECDH-P256-HMAC-SHA256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-P256-HMAC-SHA256-priv](#id-MLKEM768-ECDH-P256-HMAC-SHA256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-P384-HMAC-SHA256-cert](#id-MLKEM768-ECDH-P384-HMAC-SHA256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-P384-HMAC-SHA256-consistent](#id-MLKEM768-ECDH-P384-HMAC-SHA256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-P384-HMAC-SHA256-priv](#id-MLKEM768-ECDH-P384-HMAC-SHA256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-cert](#id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-consistent](#id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-priv](#id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-P384-HMAC-SHA512-cert](#id-MLKEM1024-ECDH-P384-HMAC-SHA512-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-P384-HMAC-SHA512-consistent](#id-MLKEM1024-ECDH-P384-HMAC-SHA512-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-P384-HMAC-SHA512-priv](#id-MLKEM1024-ECDH-P384-HMAC-SHA512-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-cert](#id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-consistent](#id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-priv](#id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-X448-SHA3-256-cert](#id-MLKEM1024-X448-SHA3-256-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-X448-SHA3-256-consistent](#id-MLKEM1024-X448-SHA3-256-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-X448-SHA3-256-priv](#id-MLKEM1024-X448-SHA3-256-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-P521-HMAC-SHA512-cert](#id-MLKEM1024-ECDH-P521-HMAC-SHA512-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-P521-HMAC-SHA512-consistent](#id-MLKEM1024-ECDH-P521-HMAC-SHA512-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-ECDH-P521-HMAC-SHA512-priv](#id-MLKEM1024-ECDH-P521-HMAC-SHA512-priv)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-RSA3072-HMAC-SHA512-cert](#id-MLKEM1024-RSA3072-HMAC-SHA512-cert)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-RSA3072-HMAC-SHA512-consistent](#id-MLKEM1024-RSA3072-HMAC-SHA512-consistent)||||✅ 1/1|||||✅ 1/1|||||
|[id-MLKEM1024-RSA3072-HMAC-SHA512-priv](#id-MLKEM1024-RSA3072-HMAC-SHA512-priv)||||✅ 1/1|||||✅ 1/1|||||
|[MLDSA44-RSA2048-PSS-SHA256-cert](#MLDSA44-RSA2048-PSS-SHA256-cert)|✅ 1/1|||||||||||||
|[MLDSA44-RSA2048-PKCS15-SHA256-cert](#MLDSA44-RSA2048-PKCS15-SHA256-cert)|✅ 1/1|||||||||||||
|[MLDSA44-ED25519-SHA512-cert](#MLDSA44-ED25519-SHA512-cert)|✅ 1/1|||||||||||||
|[MLDSA44-ECDSA-P256-SHA256-cert](#MLDSA44-ECDSA-P256-SHA256-cert)|✅ 1/1|||||||||||||
|[MLDSA65-RSA3072-PKCS15-SHA256-cert](#MLDSA65-RSA3072-PKCS15-SHA256-cert)|✅ 1/1|||||||||||||
|[MLDSA65-ECDSA-P384-SHA384-cert](#MLDSA65-ECDSA-P384-SHA384-cert)|✅ 1/1|||||||||||||
|[MLDSA65-ECDSA-BRAINPOOLP256R1-SHA256-cert](#MLDSA65-ECDSA-BRAINPOOLP256R1-SHA256-cert)|✅ 1/1|||||||||||||
|[MLDSA65-ED25519-SHA512-cert](#MLDSA65-ED25519-SHA512-cert)|✅ 1/1|||||||||||||
|[MLDSA87-ECDSA-P384-SHA384-cert](#MLDSA87-ECDSA-P384-SHA384-cert)|✅ 1/1|||||||||||||
|[MLDSA87-ECDSA-BRAINPOOLP384R1-SHA384-cert](#MLDSA87-ECDSA-BRAINPOOLP384R1-SHA384-cert)|✅ 1/1|||||||||||||
|[MLDSA87-ED448-SHA512-cert](#MLDSA87-ED448-SHA512-cert)|✅ 1/1|||||||||||||
|[MLDSA65-RSA4096-PSS-SHA384-cert](#MLDSA65-RSA4096-PSS-SHA384-cert)|✅ 1/1|||||||||||||
|[MLDSA65-RSA4096-PKCS15-SHA384-cert](#MLDSA65-RSA4096-PKCS15-SHA384-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA44-RSA2048-PKCS15-SHA256-cert](#HASHMLDSA44-RSA2048-PKCS15-SHA256-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA44-ED25519-SHA512-cert](#HASHMLDSA44-ED25519-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA44-ECDSA-P256-SHA256-cert](#HASHMLDSA44-ECDSA-P256-SHA256-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA65-RSA3072-PSS-SHA512-cert](#HASHMLDSA65-RSA3072-PSS-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA65-RSA3072-PKCS15-SHA512-cert](#HASHMLDSA65-RSA3072-PKCS15-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA65-RSA4096-PSS-SHA512-cert](#HASHMLDSA65-RSA4096-PSS-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA65-RSA4096-PKCS15-SHA512-cert](#HASHMLDSA65-RSA4096-PKCS15-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA65-ECDSA-P384-SHA512-cert](#HASHMLDSA65-ECDSA-P384-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA65-ECDSA-BRAINPOOLP256R1-SHA512-cert](#HASHMLDSA65-ECDSA-BRAINPOOLP256R1-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA65-ED25519-SHA512-cert](#HASHMLDSA65-ED25519-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA87-ECDSA-P384-SHA512-cert](#HASHMLDSA87-ECDSA-P384-SHA512-cert)|✅ 1/1|||||||||||||
|[HASHMLDSA87-ECDSA-BRAINPOOLP384R1-SHA512-cert](#HASHMLDSA87-ECDSA-BRAINPOOLP384R1-SHA512-cert)|✅ 1/1|||||||||||||

# Falcon-1024-cert (1.3.9999.3.9-cert) {#Falcon-1024-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust||||✅|||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# Falcon-1024-consistent (1.3.9999.3.9-consistent) {#Falcon-1024-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||❌|||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust||||❌|||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# Falcon-1024-priv (1.3.9999.3.9-priv) {#Falcon-1024-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||❌|||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust||||❌|||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-DSA-44-both (2.16.840.1.101.3.4.3.17-both) {#ML-DSA-44-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|✅|✅|✅|✅|✅|✅|
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-44-cert (2.16.840.1.101.3.4.3.17-cert) {#ML-DSA-44-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|✅||✅|✅|✅|
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl||✅|||||
|composite-sigs-ref-impl||||✅|||
|corey-digicert|✅|✅||✅|✅|✅|
|crypto4a|✅|✅||✅|✅|✅|
|cryptonext|✅|✅||✅|✅|❌|
|entrust|✅|✅||✅|✅|❌|
|ossl35|✅|✅||✅|✅|✅|
|safelogic|✅|||✅|||
|seventhsense.ai||||✅|||

# ML-DSA-44-consistent (2.16.840.1.101.3.4.3.17-consistent) {#ML-DSA-44-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅|✅|
|carl-redhound|✅|||✅|✅|✅|
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl||||✅|||
|corey-digicert|✅|||✅|✅|✅|
|crypto4a|✅|||✅|✅|✅|
|cryptonext|✅|||✅|✅|✅|
|entrust|✅|||❌|||
|ossl35|✅|||✅|✅|✅|
|safelogic|✅|||✅|||
|seventhsense.ai||||✅|||

# ML-DSA-44-expandedkey (2.16.840.1.101.3.4.3.17-expandedkey) {#ML-DSA-44-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|||||||
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|✅|✅|❌|❌|❌|❌|
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|✅||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-44-priv (2.16.840.1.101.3.4.3.17-priv) {#ML-DSA-44-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||✅|✅|||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-DSA-44-seed (2.16.840.1.101.3.4.3.17-seed) {#ML-DSA-44-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|||||||
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-65-both (2.16.840.1.101.3.4.3.18-both) {#ML-DSA-65-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|✅|✅|✅|✅|✅|✅|
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-65-cert (2.16.840.1.101.3.4.3.18-cert) {#ML-DSA-65-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|✅||✅|✅|✅|
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl||||✅|||
|corey-digicert|✅|✅||✅|✅|✅|
|crypto4a|✅|✅||✅|✅|✅|
|cryptonext|✅|✅||✅|✅|❌|
|entrust|✅|✅||✅|✅|❌|
|ossl35|✅|✅||✅|✅|✅|
|safelogic|✅|||✅|||
|seventhsense.ai||||✅|||

# ML-DSA-65-consistent (2.16.840.1.101.3.4.3.18-consistent) {#ML-DSA-65-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅|✅|
|carl-redhound|✅|||✅|✅|✅|
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl||||✅|||
|corey-digicert|✅|||✅|✅|✅|
|crypto4a|✅|||✅|✅|✅|
|cryptonext|✅|||✅|✅|✅|
|entrust|✅|||❌|||
|ossl35|✅|||✅|✅|✅|
|safelogic|✅|||✅|||
|seventhsense.ai||||✅|||

# ML-DSA-65-expandedkey (2.16.840.1.101.3.4.3.18-expandedkey) {#ML-DSA-65-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|||||||
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|✅|✅|❌|❌|❌|❌|
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|✅||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-65-priv (2.16.840.1.101.3.4.3.18-priv) {#ML-DSA-65-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||✅|✅|||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-DSA-65-seed (2.16.840.1.101.3.4.3.18-seed) {#ML-DSA-65-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|||||||
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-87-both (2.16.840.1.101.3.4.3.19-both) {#ML-DSA-87-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|✅|✅|✅|✅|✅|✅|
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-87-cert (2.16.840.1.101.3.4.3.19-cert) {#ML-DSA-87-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|✅||✅|✅|✅|
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl||||✅|||
|corey-digicert|✅|✅||✅|✅|✅|
|crypto4a|✅|✅||✅|✅|✅|
|cryptonext|✅|✅||✅|✅|❌|
|entrust|✅|✅||✅|✅|❌|
|ossl35|✅|✅||✅|✅|✅|
|safelogic|✅|||✅|||
|seventhsense.ai||||✅|||

# ML-DSA-87-consistent (2.16.840.1.101.3.4.3.19-consistent) {#ML-DSA-87-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅|✅|
|carl-redhound|✅|||✅|✅|✅|
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl||||✅|||
|corey-digicert|✅|||✅|✅|✅|
|crypto4a|✅|||✅|✅|✅|
|cryptonext|✅|||✅|✅|✅|
|entrust|✅|||❌|||
|ossl35|✅|||✅|✅|✅|
|safelogic|✅|||✅|||
|seventhsense.ai||||✅|||

# ML-DSA-87-expandedkey (2.16.840.1.101.3.4.3.19-expandedkey) {#ML-DSA-87-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|||||||
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|✅||||||
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|✅||✅|✅|||
|seventhsense.ai|||❌|✅|||

# ML-DSA-87-priv (2.16.840.1.101.3.4.3.19-priv) {#ML-DSA-87-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||✅|✅|||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust||✅|❌|❌|||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-DSA-87-seed (2.16.840.1.101.3.4.3.19-seed) {#ML-DSA-87-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|✅|✅|✅|✅|✅|
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|✅|✅|✅|✅|✅|✅|
|crypto4a|||||||
|cryptonext|✅|✅|✅|✅|✅|✅|
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅|✅|
|safelogic|||✅|✅|||
|seventhsense.ai|||❌|✅|||

# SLH-DSA-SHA2-128s-both (2.16.840.1.101.3.4.3.20-both) {#SLH-DSA-SHA2-128s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-128s-cert (2.16.840.1.101.3.4.3.20-cert) {#SLH-DSA-SHA2-128s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-128s-consistent (2.16.840.1.101.3.4.3.20-consistent) {#SLH-DSA-SHA2-128s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-128s-expandedkey (2.16.840.1.101.3.4.3.20-expandedkey) {#SLH-DSA-SHA2-128s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-128s-priv (2.16.840.1.101.3.4.3.20-priv) {#SLH-DSA-SHA2-128s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHA2-128s-seed (2.16.840.1.101.3.4.3.20-seed) {#SLH-DSA-SHA2-128s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-128f-both (2.16.840.1.101.3.4.3.21-both) {#SLH-DSA-SHA2-128f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-128f-cert (2.16.840.1.101.3.4.3.21-cert) {#SLH-DSA-SHA2-128f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-128f-consistent (2.16.840.1.101.3.4.3.21-consistent) {#SLH-DSA-SHA2-128f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-128f-expandedkey (2.16.840.1.101.3.4.3.21-expandedkey) {#SLH-DSA-SHA2-128f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-128f-priv (2.16.840.1.101.3.4.3.21-priv) {#SLH-DSA-SHA2-128f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHA2-128f-seed (2.16.840.1.101.3.4.3.21-seed) {#SLH-DSA-SHA2-128f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-192s-both (2.16.840.1.101.3.4.3.22-both) {#SLH-DSA-SHA2-192s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-192s-cert (2.16.840.1.101.3.4.3.22-cert) {#SLH-DSA-SHA2-192s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-192s-consistent (2.16.840.1.101.3.4.3.22-consistent) {#SLH-DSA-SHA2-192s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-192s-expandedkey (2.16.840.1.101.3.4.3.22-expandedkey) {#SLH-DSA-SHA2-192s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-192s-priv (2.16.840.1.101.3.4.3.22-priv) {#SLH-DSA-SHA2-192s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHA2-192s-seed (2.16.840.1.101.3.4.3.22-seed) {#SLH-DSA-SHA2-192s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-192f-both (2.16.840.1.101.3.4.3.23-both) {#SLH-DSA-SHA2-192f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-192f-cert (2.16.840.1.101.3.4.3.23-cert) {#SLH-DSA-SHA2-192f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-192f-consistent (2.16.840.1.101.3.4.3.23-consistent) {#SLH-DSA-SHA2-192f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-192f-expandedkey (2.16.840.1.101.3.4.3.23-expandedkey) {#SLH-DSA-SHA2-192f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-192f-priv (2.16.840.1.101.3.4.3.23-priv) {#SLH-DSA-SHA2-192f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHA2-192f-seed (2.16.840.1.101.3.4.3.23-seed) {#SLH-DSA-SHA2-192f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-256s-both (2.16.840.1.101.3.4.3.24-both) {#SLH-DSA-SHA2-256s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-256s-cert (2.16.840.1.101.3.4.3.24-cert) {#SLH-DSA-SHA2-256s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-256s-consistent (2.16.840.1.101.3.4.3.24-consistent) {#SLH-DSA-SHA2-256s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-256s-expandedkey (2.16.840.1.101.3.4.3.24-expandedkey) {#SLH-DSA-SHA2-256s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-256s-priv (2.16.840.1.101.3.4.3.24-priv) {#SLH-DSA-SHA2-256s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHA2-256s-seed (2.16.840.1.101.3.4.3.24-seed) {#SLH-DSA-SHA2-256s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-256f-both (2.16.840.1.101.3.4.3.25-both) {#SLH-DSA-SHA2-256f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-256f-cert (2.16.840.1.101.3.4.3.25-cert) {#SLH-DSA-SHA2-256f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-256f-consistent (2.16.840.1.101.3.4.3.25-consistent) {#SLH-DSA-SHA2-256f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHA2-256f-expandedkey (2.16.840.1.101.3.4.3.25-expandedkey) {#SLH-DSA-SHA2-256f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHA2-256f-priv (2.16.840.1.101.3.4.3.25-priv) {#SLH-DSA-SHA2-256f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHA2-256f-seed (2.16.840.1.101.3.4.3.25-seed) {#SLH-DSA-SHA2-256f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-128s-both (2.16.840.1.101.3.4.3.26-both) {#SLH-DSA-SHAKE-128s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-128s-cert (2.16.840.1.101.3.4.3.26-cert) {#SLH-DSA-SHAKE-128s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-128s-consistent (2.16.840.1.101.3.4.3.26-consistent) {#SLH-DSA-SHAKE-128s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-128s-expandedkey (2.16.840.1.101.3.4.3.26-expandedkey) {#SLH-DSA-SHAKE-128s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-128s-priv (2.16.840.1.101.3.4.3.26-priv) {#SLH-DSA-SHAKE-128s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHAKE-128s-seed (2.16.840.1.101.3.4.3.26-seed) {#SLH-DSA-SHAKE-128s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-128f-both (2.16.840.1.101.3.4.3.27-both) {#SLH-DSA-SHAKE-128f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-128f-cert (2.16.840.1.101.3.4.3.27-cert) {#SLH-DSA-SHAKE-128f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-128f-consistent (2.16.840.1.101.3.4.3.27-consistent) {#SLH-DSA-SHAKE-128f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-128f-expandedkey (2.16.840.1.101.3.4.3.27-expandedkey) {#SLH-DSA-SHAKE-128f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-128f-priv (2.16.840.1.101.3.4.3.27-priv) {#SLH-DSA-SHAKE-128f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHAKE-128f-seed (2.16.840.1.101.3.4.3.27-seed) {#SLH-DSA-SHAKE-128f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-192s-both (2.16.840.1.101.3.4.3.28-both) {#SLH-DSA-SHAKE-192s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-192s-cert (2.16.840.1.101.3.4.3.28-cert) {#SLH-DSA-SHAKE-192s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-192s-consistent (2.16.840.1.101.3.4.3.28-consistent) {#SLH-DSA-SHAKE-192s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-192s-expandedkey (2.16.840.1.101.3.4.3.28-expandedkey) {#SLH-DSA-SHAKE-192s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-192s-priv (2.16.840.1.101.3.4.3.28-priv) {#SLH-DSA-SHAKE-192s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHAKE-192s-seed (2.16.840.1.101.3.4.3.28-seed) {#SLH-DSA-SHAKE-192s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-192f-both (2.16.840.1.101.3.4.3.29-both) {#SLH-DSA-SHAKE-192f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-192f-cert (2.16.840.1.101.3.4.3.29-cert) {#SLH-DSA-SHAKE-192f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-192f-consistent (2.16.840.1.101.3.4.3.29-consistent) {#SLH-DSA-SHAKE-192f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-192f-expandedkey (2.16.840.1.101.3.4.3.29-expandedkey) {#SLH-DSA-SHAKE-192f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-192f-priv (2.16.840.1.101.3.4.3.29-priv) {#SLH-DSA-SHAKE-192f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHAKE-192f-seed (2.16.840.1.101.3.4.3.29-seed) {#SLH-DSA-SHAKE-192f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-256s-both (2.16.840.1.101.3.4.3.30-both) {#SLH-DSA-SHAKE-256s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-256s-cert (2.16.840.1.101.3.4.3.30-cert) {#SLH-DSA-SHAKE-256s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-256s-consistent (2.16.840.1.101.3.4.3.30-consistent) {#SLH-DSA-SHAKE-256s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-256s-expandedkey (2.16.840.1.101.3.4.3.30-expandedkey) {#SLH-DSA-SHAKE-256s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-256s-priv (2.16.840.1.101.3.4.3.30-priv) {#SLH-DSA-SHAKE-256s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHAKE-256s-seed (2.16.840.1.101.3.4.3.30-seed) {#SLH-DSA-SHAKE-256s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-256f-both (2.16.840.1.101.3.4.3.31-both) {#SLH-DSA-SHAKE-256f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-256f-cert (2.16.840.1.101.3.4.3.31-cert) {#SLH-DSA-SHAKE-256f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|✅|✅||✅|✅||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-256f-consistent (2.16.840.1.101.3.4.3.31-consistent) {#SLH-DSA-SHAKE-256f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|✅|||✅|✅||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# SLH-DSA-SHAKE-256f-expandedkey (2.16.840.1.101.3.4.3.31-expandedkey) {#SLH-DSA-SHAKE-256f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# SLH-DSA-SHAKE-256f-priv (2.16.840.1.101.3.4.3.31-priv) {#SLH-DSA-SHAKE-256f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅||
|carl-redhound|✅|✅|✅|✅|✅||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext|✅|✅|✅|✅|✅||
|entrust|||||||
|ossl35|✅|✅|✅|✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# SLH-DSA-SHAKE-256f-seed (2.16.840.1.101.3.4.3.31-seed) {#SLH-DSA-SHAKE-256f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-ML-DSA-44-both (2.16.840.1.101.3.4.3.32-both) {#HASH-ML-DSA-44-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||✅|✅|||
|crypto4a|||✅|✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-44-cert (2.16.840.1.101.3.4.3.32-cert) {#HASH-ML-DSA-44-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||✅||✅|||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-ML-DSA-44-consistent (2.16.840.1.101.3.4.3.32-consistent) {#HASH-ML-DSA-44-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||||✅|||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||❌|||

# HASH-ML-DSA-44-expandedkey (2.16.840.1.101.3.4.3.32-expandedkey) {#HASH-ML-DSA-44-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||✅|✅|||
|crypto4a|||||||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-44-seed (2.16.840.1.101.3.4.3.32-seed) {#HASH-ML-DSA-44-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||✅|✅|||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-65-both (2.16.840.1.101.3.4.3.33-both) {#HASH-ML-DSA-65-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||✅|✅|✅|||
|crypto4a|||✅|✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-65-cert (2.16.840.1.101.3.4.3.33-cert) {#HASH-ML-DSA-65-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||✅||✅|||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-ML-DSA-65-consistent (2.16.840.1.101.3.4.3.33-consistent) {#HASH-ML-DSA-65-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||||✅|||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||❌|||

# HASH-ML-DSA-65-expandedkey (2.16.840.1.101.3.4.3.33-expandedkey) {#HASH-ML-DSA-65-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||✅|✅|✅|||
|crypto4a|||||||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-65-seed (2.16.840.1.101.3.4.3.33-seed) {#HASH-ML-DSA-65-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||✅|✅|✅|||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-87-both (2.16.840.1.101.3.4.3.34-both) {#HASH-ML-DSA-87-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||✅|✅|||
|crypto4a|||✅|✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-87-cert (2.16.840.1.101.3.4.3.34-cert) {#HASH-ML-DSA-87-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||✅||✅|||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-ML-DSA-87-consistent (2.16.840.1.101.3.4.3.34-consistent) {#HASH-ML-DSA-87-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert||||✅|||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||❌|||

# HASH-ML-DSA-87-expandedkey (2.16.840.1.101.3.4.3.34-expandedkey) {#HASH-ML-DSA-87-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||✅|✅|||
|crypto4a|||||||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-ML-DSA-87-seed (2.16.840.1.101.3.4.3.34-seed) {#HASH-ML-DSA-87-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||✅|✅|||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||❌|❌|||

# HASH-SLH-DSA-SHA2-128s-both (2.16.840.1.101.3.4.3.35-both) {#HASH-SLH-DSA-SHA2-128s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-128s-cert (2.16.840.1.101.3.4.3.35-cert) {#HASH-SLH-DSA-SHA2-128s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-128s-consistent (2.16.840.1.101.3.4.3.35-consistent) {#HASH-SLH-DSA-SHA2-128s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-128s-expandedkey (2.16.840.1.101.3.4.3.35-expandedkey) {#HASH-SLH-DSA-SHA2-128s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-128s-priv (2.16.840.1.101.3.4.3.35-priv) {#HASH-SLH-DSA-SHA2-128s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHA2-128s-seed (2.16.840.1.101.3.4.3.35-seed) {#HASH-SLH-DSA-SHA2-128s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-128f-both (2.16.840.1.101.3.4.3.36-both) {#HASH-SLH-DSA-SHA2-128f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-128f-cert (2.16.840.1.101.3.4.3.36-cert) {#HASH-SLH-DSA-SHA2-128f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-128f-consistent (2.16.840.1.101.3.4.3.36-consistent) {#HASH-SLH-DSA-SHA2-128f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-128f-expandedkey (2.16.840.1.101.3.4.3.36-expandedkey) {#HASH-SLH-DSA-SHA2-128f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-128f-priv (2.16.840.1.101.3.4.3.36-priv) {#HASH-SLH-DSA-SHA2-128f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHA2-128f-seed (2.16.840.1.101.3.4.3.36-seed) {#HASH-SLH-DSA-SHA2-128f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-192s-both (2.16.840.1.101.3.4.3.37-both) {#HASH-SLH-DSA-SHA2-192s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-192s-cert (2.16.840.1.101.3.4.3.37-cert) {#HASH-SLH-DSA-SHA2-192s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-192s-consistent (2.16.840.1.101.3.4.3.37-consistent) {#HASH-SLH-DSA-SHA2-192s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-192s-expandedkey (2.16.840.1.101.3.4.3.37-expandedkey) {#HASH-SLH-DSA-SHA2-192s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-192s-priv (2.16.840.1.101.3.4.3.37-priv) {#HASH-SLH-DSA-SHA2-192s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHA2-192s-seed (2.16.840.1.101.3.4.3.37-seed) {#HASH-SLH-DSA-SHA2-192s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-192f-both (2.16.840.1.101.3.4.3.38-both) {#HASH-SLH-DSA-SHA2-192f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-192f-cert (2.16.840.1.101.3.4.3.38-cert) {#HASH-SLH-DSA-SHA2-192f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-192f-consistent (2.16.840.1.101.3.4.3.38-consistent) {#HASH-SLH-DSA-SHA2-192f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-192f-expandedkey (2.16.840.1.101.3.4.3.38-expandedkey) {#HASH-SLH-DSA-SHA2-192f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-192f-priv (2.16.840.1.101.3.4.3.38-priv) {#HASH-SLH-DSA-SHA2-192f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHA2-192f-seed (2.16.840.1.101.3.4.3.38-seed) {#HASH-SLH-DSA-SHA2-192f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-256s-both (2.16.840.1.101.3.4.3.39-both) {#HASH-SLH-DSA-SHA2-256s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-256s-cert (2.16.840.1.101.3.4.3.39-cert) {#HASH-SLH-DSA-SHA2-256s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-256s-consistent (2.16.840.1.101.3.4.3.39-consistent) {#HASH-SLH-DSA-SHA2-256s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-256s-expandedkey (2.16.840.1.101.3.4.3.39-expandedkey) {#HASH-SLH-DSA-SHA2-256s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-256s-priv (2.16.840.1.101.3.4.3.39-priv) {#HASH-SLH-DSA-SHA2-256s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHA2-256s-seed (2.16.840.1.101.3.4.3.39-seed) {#HASH-SLH-DSA-SHA2-256s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-256f-both (2.16.840.1.101.3.4.3.40-both) {#HASH-SLH-DSA-SHA2-256f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-256f-cert (2.16.840.1.101.3.4.3.40-cert) {#HASH-SLH-DSA-SHA2-256f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-256f-consistent (2.16.840.1.101.3.4.3.40-consistent) {#HASH-SLH-DSA-SHA2-256f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHA2-256f-expandedkey (2.16.840.1.101.3.4.3.40-expandedkey) {#HASH-SLH-DSA-SHA2-256f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHA2-256f-priv (2.16.840.1.101.3.4.3.40-priv) {#HASH-SLH-DSA-SHA2-256f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHA2-256f-seed (2.16.840.1.101.3.4.3.40-seed) {#HASH-SLH-DSA-SHA2-256f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-128s-both (2.16.840.1.101.3.4.3.41-both) {#HASH-SLH-DSA-SHAKE-128s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-128s-cert (2.16.840.1.101.3.4.3.41-cert) {#HASH-SLH-DSA-SHAKE-128s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-128s-consistent (2.16.840.1.101.3.4.3.41-consistent) {#HASH-SLH-DSA-SHAKE-128s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-128s-expandedkey (2.16.840.1.101.3.4.3.41-expandedkey) {#HASH-SLH-DSA-SHAKE-128s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-128s-priv (2.16.840.1.101.3.4.3.41-priv) {#HASH-SLH-DSA-SHAKE-128s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHAKE-128s-seed (2.16.840.1.101.3.4.3.41-seed) {#HASH-SLH-DSA-SHAKE-128s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-128f-both (2.16.840.1.101.3.4.3.42-both) {#HASH-SLH-DSA-SHAKE-128f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-128f-cert (2.16.840.1.101.3.4.3.42-cert) {#HASH-SLH-DSA-SHAKE-128f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-128f-consistent (2.16.840.1.101.3.4.3.42-consistent) {#HASH-SLH-DSA-SHAKE-128f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-128f-expandedkey (2.16.840.1.101.3.4.3.42-expandedkey) {#HASH-SLH-DSA-SHAKE-128f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-128f-priv (2.16.840.1.101.3.4.3.42-priv) {#HASH-SLH-DSA-SHAKE-128f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHAKE-128f-seed (2.16.840.1.101.3.4.3.42-seed) {#HASH-SLH-DSA-SHAKE-128f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-192s-both (2.16.840.1.101.3.4.3.43-both) {#HASH-SLH-DSA-SHAKE-192s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-192s-cert (2.16.840.1.101.3.4.3.43-cert) {#HASH-SLH-DSA-SHAKE-192s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-192s-consistent (2.16.840.1.101.3.4.3.43-consistent) {#HASH-SLH-DSA-SHAKE-192s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-192s-expandedkey (2.16.840.1.101.3.4.3.43-expandedkey) {#HASH-SLH-DSA-SHAKE-192s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-192s-priv (2.16.840.1.101.3.4.3.43-priv) {#HASH-SLH-DSA-SHAKE-192s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHAKE-192s-seed (2.16.840.1.101.3.4.3.43-seed) {#HASH-SLH-DSA-SHAKE-192s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-192f-both (2.16.840.1.101.3.4.3.44-both) {#HASH-SLH-DSA-SHAKE-192f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-192f-cert (2.16.840.1.101.3.4.3.44-cert) {#HASH-SLH-DSA-SHAKE-192f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-192f-consistent (2.16.840.1.101.3.4.3.44-consistent) {#HASH-SLH-DSA-SHAKE-192f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-192f-expandedkey (2.16.840.1.101.3.4.3.44-expandedkey) {#HASH-SLH-DSA-SHAKE-192f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-192f-priv (2.16.840.1.101.3.4.3.44-priv) {#HASH-SLH-DSA-SHAKE-192f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHAKE-192f-seed (2.16.840.1.101.3.4.3.44-seed) {#HASH-SLH-DSA-SHAKE-192f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-256s-both (2.16.840.1.101.3.4.3.45-both) {#HASH-SLH-DSA-SHAKE-256s-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-256s-cert (2.16.840.1.101.3.4.3.45-cert) {#HASH-SLH-DSA-SHAKE-256s-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-256s-consistent (2.16.840.1.101.3.4.3.45-consistent) {#HASH-SLH-DSA-SHAKE-256s-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-256s-expandedkey (2.16.840.1.101.3.4.3.45-expandedkey) {#HASH-SLH-DSA-SHAKE-256s-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-256s-priv (2.16.840.1.101.3.4.3.45-priv) {#HASH-SLH-DSA-SHAKE-256s-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHAKE-256s-seed (2.16.840.1.101.3.4.3.45-seed) {#HASH-SLH-DSA-SHAKE-256s-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-256f-both (2.16.840.1.101.3.4.3.46-both) {#HASH-SLH-DSA-SHAKE-256f-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-256f-cert (2.16.840.1.101.3.4.3.46-cert) {#HASH-SLH-DSA-SHAKE-256f-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||✅||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-256f-consistent (2.16.840.1.101.3.4.3.46-consistent) {#HASH-SLH-DSA-SHAKE-256f-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||✅|||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a||||✅|||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||✅|||

# HASH-SLH-DSA-SHAKE-256f-expandedkey (2.16.840.1.101.3.4.3.46-expandedkey) {#HASH-SLH-DSA-SHAKE-256f-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# HASH-SLH-DSA-SHAKE-256f-priv (2.16.840.1.101.3.4.3.46-priv) {#HASH-SLH-DSA-SHAKE-256f-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|✅|✅|||
|carl-redhound|||||||
|cht||✅|✅|✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||✅|✅|||
|cryptonext||✅|✅|✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASH-SLH-DSA-SHAKE-256f-seed (2.16.840.1.101.3.4.3.46-seed) {#HASH-SLH-DSA-SHAKE-256f-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||✅|✅|||

# ML-KEM-512-both (2.16.840.1.101.3.4.4.1-both) {#ML-KEM-512-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-512-cert (2.16.840.1.101.3.4.4.1-cert) {#ML-KEM-512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# ML-KEM-512-consistent (2.16.840.1.101.3.4.4.1-consistent) {#ML-KEM-512-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# ML-KEM-512-expandedkey (2.16.840.1.101.3.4.4.1-expandedkey) {#ML-KEM-512-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-512-priv (2.16.840.1.101.3.4.4.1-priv) {#ML-KEM-512-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||❌|||

# ML-KEM-512-seed (2.16.840.1.101.3.4.4.1-seed) {#ML-KEM-512-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-768-both (2.16.840.1.101.3.4.4.2-both) {#ML-KEM-768-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-768-cert (2.16.840.1.101.3.4.4.2-cert) {#ML-KEM-768-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# ML-KEM-768-consistent (2.16.840.1.101.3.4.4.2-consistent) {#ML-KEM-768-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# ML-KEM-768-expandedkey (2.16.840.1.101.3.4.4.2-expandedkey) {#ML-KEM-768-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-768-priv (2.16.840.1.101.3.4.4.2-priv) {#ML-KEM-768-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||❌|||

# ML-KEM-768-seed (2.16.840.1.101.3.4.4.2-seed) {#ML-KEM-768-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-1024-both (2.16.840.1.101.3.4.4.3-both) {#ML-KEM-1024-both}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-1024-cert (2.16.840.1.101.3.4.4.3-cert) {#ML-KEM-1024-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||✅|||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# ML-KEM-1024-consistent (2.16.840.1.101.3.4.4.3-consistent) {#ML-KEM-1024-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅||
|carl-redhound|||||||
|cht||||✅|||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|||✅|✅||
|entrust|||||||
|ossl35|✅|||✅|✅||
|safelogic|||||||
|seventhsense.ai||||✅|||

# ML-KEM-1024-expandedkey (2.16.840.1.101.3.4.4.3-expandedkey) {#ML-KEM-1024-expandedkey}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# ML-KEM-1024-priv (2.16.840.1.101.3.4.4.3-priv) {#ML-KEM-1024-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai||||❌|||

# ML-KEM-1024-seed (2.16.840.1.101.3.4.4.3-seed) {#ML-KEM-1024-seed}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅||
|carl-redhound|||||||
|cht||✅||❌|||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|✅|✅||✅|✅||
|entrust|||||||
|ossl35|✅|✅||✅|✅||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA2048-HMAC-SHA256-cert (2.16.840.1.114027.80.5.2.50-cert) {#id-MLKEM768-RSA2048-HMAC-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA2048-HMAC-SHA256-consistent (2.16.840.1.114027.80.5.2.50-consistent) {#id-MLKEM768-RSA2048-HMAC-SHA256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA2048-HMAC-SHA256-priv (2.16.840.1.114027.80.5.2.50-priv) {#id-MLKEM768-RSA2048-HMAC-SHA256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA3072-HMAC-SHA256-cert (2.16.840.1.114027.80.5.2.51-cert) {#id-MLKEM768-RSA3072-HMAC-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA3072-HMAC-SHA256-consistent (2.16.840.1.114027.80.5.2.51-consistent) {#id-MLKEM768-RSA3072-HMAC-SHA256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA3072-HMAC-SHA256-priv (2.16.840.1.114027.80.5.2.51-priv) {#id-MLKEM768-RSA3072-HMAC-SHA256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA4096-HMAC-SHA256-cert (2.16.840.1.114027.80.5.2.52-cert) {#id-MLKEM768-RSA4096-HMAC-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA4096-HMAC-SHA256-consistent (2.16.840.1.114027.80.5.2.52-consistent) {#id-MLKEM768-RSA4096-HMAC-SHA256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-RSA4096-HMAC-SHA256-priv (2.16.840.1.114027.80.5.2.52-priv) {#id-MLKEM768-RSA4096-HMAC-SHA256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-X25519-SHA3-256-cert (2.16.840.1.114027.80.5.2.53-cert) {#id-MLKEM768-X25519-SHA3-256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-X25519-SHA3-256-consistent (2.16.840.1.114027.80.5.2.53-consistent) {#id-MLKEM768-X25519-SHA3-256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-X25519-SHA3-256-priv (2.16.840.1.114027.80.5.2.53-priv) {#id-MLKEM768-X25519-SHA3-256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-P256-HMAC-SHA256-cert (2.16.840.1.114027.80.5.2.54-cert) {#id-MLKEM768-ECDH-P256-HMAC-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-P256-HMAC-SHA256-consistent (2.16.840.1.114027.80.5.2.54-consistent) {#id-MLKEM768-ECDH-P256-HMAC-SHA256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-P256-HMAC-SHA256-priv (2.16.840.1.114027.80.5.2.54-priv) {#id-MLKEM768-ECDH-P256-HMAC-SHA256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-P384-HMAC-SHA256-cert (2.16.840.1.114027.80.5.2.55-cert) {#id-MLKEM768-ECDH-P384-HMAC-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-P384-HMAC-SHA256-consistent (2.16.840.1.114027.80.5.2.55-consistent) {#id-MLKEM768-ECDH-P384-HMAC-SHA256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-P384-HMAC-SHA256-priv (2.16.840.1.114027.80.5.2.55-priv) {#id-MLKEM768-ECDH-P384-HMAC-SHA256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-cert (2.16.840.1.114027.80.5.2.56-cert) {#id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-consistent (2.16.840.1.114027.80.5.2.56-consistent) {#id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-priv (2.16.840.1.114027.80.5.2.56-priv) {#id-MLKEM768-ECDH-brainpoolP256r1-HMAC-SHA256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-P384-HMAC-SHA512-cert (2.16.840.1.114027.80.5.2.57-cert) {#id-MLKEM1024-ECDH-P384-HMAC-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-P384-HMAC-SHA512-consistent (2.16.840.1.114027.80.5.2.57-consistent) {#id-MLKEM1024-ECDH-P384-HMAC-SHA512-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-P384-HMAC-SHA512-priv (2.16.840.1.114027.80.5.2.57-priv) {#id-MLKEM1024-ECDH-P384-HMAC-SHA512-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-cert (2.16.840.1.114027.80.5.2.58-cert) {#id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-consistent (2.16.840.1.114027.80.5.2.58-consistent) {#id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-priv (2.16.840.1.114027.80.5.2.58-priv) {#id-MLKEM1024-ECDH-brainpoolP384r1-HMAC-SHA512-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-X448-SHA3-256-cert (2.16.840.1.114027.80.5.2.59-cert) {#id-MLKEM1024-X448-SHA3-256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-X448-SHA3-256-consistent (2.16.840.1.114027.80.5.2.59-consistent) {#id-MLKEM1024-X448-SHA3-256-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-X448-SHA3-256-priv (2.16.840.1.114027.80.5.2.59-priv) {#id-MLKEM1024-X448-SHA3-256-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-P521-HMAC-SHA512-cert (2.16.840.1.114027.80.5.2.60-cert) {#id-MLKEM1024-ECDH-P521-HMAC-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-P521-HMAC-SHA512-consistent (2.16.840.1.114027.80.5.2.60-consistent) {#id-MLKEM1024-ECDH-P521-HMAC-SHA512-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-ECDH-P521-HMAC-SHA512-priv (2.16.840.1.114027.80.5.2.60-priv) {#id-MLKEM1024-ECDH-P521-HMAC-SHA512-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-RSA3072-HMAC-SHA512-cert (2.16.840.1.114027.80.5.2.61-cert) {#id-MLKEM1024-RSA3072-HMAC-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-RSA3072-HMAC-SHA512-consistent (2.16.840.1.114027.80.5.2.61-consistent) {#id-MLKEM1024-RSA3072-HMAC-SHA512-consistent}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# id-MLKEM1024-RSA3072-HMAC-SHA512-priv (2.16.840.1.114027.80.5.2.61-priv) {#id-MLKEM1024-RSA3072-HMAC-SHA512-priv}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl||||✅|||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext||||✅|||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA44-RSA2048-PSS-SHA256-cert (2.16.840.1.114027.80.8.1.21-cert) {#MLDSA44-RSA2048-PSS-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA44-RSA2048-PKCS15-SHA256-cert (2.16.840.1.114027.80.8.1.22-cert) {#MLDSA44-RSA2048-PKCS15-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA44-ED25519-SHA512-cert (2.16.840.1.114027.80.8.1.23-cert) {#MLDSA44-ED25519-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA44-ECDSA-P256-SHA256-cert (2.16.840.1.114027.80.8.1.24-cert) {#MLDSA44-ECDSA-P256-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA65-RSA3072-PKCS15-SHA256-cert (2.16.840.1.114027.80.8.1.27-cert) {#MLDSA65-RSA3072-PKCS15-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA65-ECDSA-P384-SHA384-cert (2.16.840.1.114027.80.8.1.28-cert) {#MLDSA65-ECDSA-P384-SHA384-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA65-ECDSA-BRAINPOOLP256R1-SHA256-cert (2.16.840.1.114027.80.8.1.29-cert) {#MLDSA65-ECDSA-BRAINPOOLP256R1-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA65-ED25519-SHA512-cert (2.16.840.1.114027.80.8.1.30-cert) {#MLDSA65-ED25519-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA87-ECDSA-P384-SHA384-cert (2.16.840.1.114027.80.8.1.31-cert) {#MLDSA87-ECDSA-P384-SHA384-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA87-ECDSA-BRAINPOOLP384R1-SHA384-cert (2.16.840.1.114027.80.8.1.32-cert) {#MLDSA87-ECDSA-BRAINPOOLP384R1-SHA384-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA87-ED448-SHA512-cert (2.16.840.1.114027.80.8.1.33-cert) {#MLDSA87-ED448-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA65-RSA4096-PSS-SHA384-cert (2.16.840.1.114027.80.8.1.34-cert) {#MLDSA65-RSA4096-PSS-SHA384-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# MLDSA65-RSA4096-PKCS15-SHA384-cert (2.16.840.1.114027.80.8.1.35-cert) {#MLDSA65-RSA4096-PKCS15-SHA384-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA44-RSA2048-PKCS15-SHA256-cert (2.16.840.1.114027.80.8.1.41-cert) {#HASHMLDSA44-RSA2048-PKCS15-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA44-ED25519-SHA512-cert (2.16.840.1.114027.80.8.1.42-cert) {#HASHMLDSA44-ED25519-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA44-ECDSA-P256-SHA256-cert (2.16.840.1.114027.80.8.1.43-cert) {#HASHMLDSA44-ECDSA-P256-SHA256-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA65-RSA3072-PSS-SHA512-cert (2.16.840.1.114027.80.8.1.44-cert) {#HASHMLDSA65-RSA3072-PSS-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA65-RSA3072-PKCS15-SHA512-cert (2.16.840.1.114027.80.8.1.45-cert) {#HASHMLDSA65-RSA3072-PKCS15-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA65-RSA4096-PSS-SHA512-cert (2.16.840.1.114027.80.8.1.46-cert) {#HASHMLDSA65-RSA4096-PSS-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA65-RSA4096-PKCS15-SHA512-cert (2.16.840.1.114027.80.8.1.47-cert) {#HASHMLDSA65-RSA4096-PKCS15-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA65-ECDSA-P384-SHA512-cert (2.16.840.1.114027.80.8.1.48-cert) {#HASHMLDSA65-ECDSA-P384-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA65-ECDSA-BRAINPOOLP256R1-SHA512-cert (2.16.840.1.114027.80.8.1.49-cert) {#HASHMLDSA65-ECDSA-BRAINPOOLP256R1-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA65-ED25519-SHA512-cert (2.16.840.1.114027.80.8.1.50-cert) {#HASHMLDSA65-ED25519-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA87-ECDSA-P384-SHA512-cert (2.16.840.1.114027.80.8.1.51-cert) {#HASHMLDSA87-ECDSA-P384-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||

# HASHMLDSA87-ECDSA-BRAINPOOLP384R1-SHA512-cert (2.16.840.1.114027.80.8.1.52-cert) {#HASHMLDSA87-ECDSA-BRAINPOOLP384R1-SHA512-cert}


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|crypto4a|cryptonext|ossl35|safelogic|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||||
|carl-redhound|||||||
|cht|||||||
|composite-kem-ref-impl|||||||
|composite-ref-impl|||||||
|composite-sigs-ref-impl|||||||
|corey-digicert|||||||
|crypto4a|||||||
|cryptonext|||||||
|entrust|||||||
|ossl35|||||||
|safelogic|||||||
|seventhsense.ai|||||||
