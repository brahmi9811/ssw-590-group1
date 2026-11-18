# Final report: Configuring and Running the DevOps Pipeline (due Thu Dec 17, 2026)

Preferably a **separate document** (decision D10, pending the professor's answer) that follows the structure and template of our manual (the course DevOpsTemplate: one chapter file per chapter, glossary, index, document history, citations) and lives in `report/` of the new GitHub repository, so the pipeline builds it (docs as code). It contains the chapter titled exactly **Configuring and Running the DevOps Pipeline**; whether a separate PDF satisfies the Canvas wording "Add a chapter" is open question 1 for the instructor.
Placeholders are marked `[PENDING]` until the run exists, and nothing is called PASS without evidence. The update history and clickable links are part of the rubric (row R9).

| Section | Content | Rubric | Writer |
|---|---|---|---|
| Front matter | title, authors, version in the format `major.minor.changelist`, document history, AI attribution as in the course template | R9 | both |
| 1 Overview | the project, the pipeline in one figure, how it relates to the proposal (GitHub Actions and Jenkins, one pipeline run live), the V-curve steps a) to h) and the tool for each | R1 to R9 | both |
| 2 Issue tracking (a) | GitHub Issues; the demo issue and the comment; link | R1 | SD |
| 3 Source control (b) | Git and GitHub, the branch rule and review, the demo commit and message | R2 | SD |
| 4 Architecture forward documentation (c) | LaTeX with the TeX Live container (the same family as Overleaf), the small `docs/` document and how this report is built | R4 | SD |
| 5 CI/CD tools (d) | the Jenkins pipeline: stages, trigger (webhook and button), agent; the GitHub Actions workflow; stage evidence from both | R3, R4 | BD (Jenkins), SD (Actions) |
| 6 Testing (e) | `unittest`, pass and fail evidence | R5 | SD |
| 7 Deployment and artifact (f) | Docker and the ZIP, `major.minor.changelist`, where the number comes from | R6 | SD |
| 8 Monitoring (g) and cloud execution (bonus) | Prometheus, Grafana, Node Exporter on the project server; the configuration for cloud execution and the load change during a run; limits of the sampling | R bonus cloud | BD |
| 9 Reverse documentation (h, bonus) | pyreverse and Graphviz configuration, the generated diagrams in the artifact | R bonus reverse | SD |
| 10 SWOT of two tools | Jenkins and GitHub Actions: four quadrants each, facts and evidence lines | R7 | both |
| 11 Configuration files | one page per file: what it does for the pipeline, links to the files in the repository | R8 | BD |
| 12 The project server and costs | the AWS server, security group, DNS, HTTPS, budget, the stop or teardown record | R9 | BD |
| 13 Limitations and future work | what was not done, risks met, what we would change | R9 | both |
| Bibliography, glossary, index | as in the template | R9 | both |

Rules: sentences state only what was measured or shown; failed attempts are described with the fix; secrets, webhook secrets or tokens never appear; AI assistance is attributed as in the course template.
