# Canvas text of the final project (pasted by Brahmi on Nov 17, 2026; instructor text, kept as received)

Two graded items belong to the final project:
1. **Final Project Demo -- Group**: a 20-minute live demonstration with Q/A. Canvas shows it due **Mon Dec 7, 2026, 11:59 pm** (confirm the actual demo slot or date).
2. **Final Project Report -- Group**: due **Thu Dec 17, 2026, 11:59 pm**, 100 points.

---

## 1. Final Project Demo: "DevOps & Reverse Engineering Workflow Requirements (20 min with Q/A)"

This evaluation measures your ability to implement a full DevOps pipeline, including issue tracking, version control, CI/CD automation, testing, deployment packaging, and code-based architecture documentation.
You will demonstrate a system that includes the following components:

### Required Workflow (Graded)
1. **Issue Tracking Integration.** Show your issue tracking tool (e.g., GitHub Issues, Jira). Select an existing issue and submit a comment describing the fix or enhancement you are about to perform.
2. **Source Code or LaTeX Update.** Make a meaningful change to your codebase or LaTeX document. Push the change to source control (e.g., GitHub) with a clear and relevant commit message.
3. **Pipeline Triggering.** Start your CI/CD pipeline automatically (on commit) or manually (e.g., button press, script). This should kick off the full end-to-end build process.
4. **Build Process Visibility.** Your pipeline should visibly show progress steps, including: compiling LaTeX output; building or compiling project source code; packaging the project (e.g., ZIP of your deployed code or container image).
5. **Automated Testing.** Your pipeline must run automated tests and show clear pass/fail results.
6. **Deployment Artifact with Versioning.** Generate a deployment-ready artifact with semantic versioning in the format: major.minor.changelist (e.g., 1.0.245). This artifact may be a ZIP file, container image tag, or other deployable output.
7. **SWOT Analysis of Two Tools.** Choose two tools used in your DevOps workflow and compare them using a SWOT chart: Strengths, Weaknesses, Opportunities, Threats.
8. **Configuration Files Presentation.** Show and explain your configuration files (e.g., YAML CI configs, Docker configs, build scripts). Demonstrate understanding of how each configuration contributes to your DevOps pipeline. Show part of your pipeline running on a cloud instance (e.g., Digital Ocean). Demonstrate changes in system load (CPU, memory, disk, etc.) during the build/test process.

**(+5 Bonus) Reverse Architecture Documentation.** Use a source-code-based reverse documentation tool to generate architectural diagrams. Acceptable tools include: Doxygen + Graphviz; Pyreverse (Pylint); TypeScript PlantUML; Eclipse UML Generators; Visual Studio Class Designer; any similar tool that extracts architecture from source code. Demo the generated diagrams in your final deployment output or documentation.

### DevOps & Documentation Rubric (demo): 100 points + 5 bonus
| # | Category | Description | Points |
|---|---|---|---|
| 1 | Issue Tracking | Uses issue tracker and submits relevant comment tied to work | 10 |
| 2 | Version Control Update | Meaningful change committed with appropriate message | 10 |
| 3 | CI/CD Pipeline Trigger | Demonstrates manual/automatic triggering of pipeline | 10 |
| 4 | Build Visibility | Pipeline clearly shows compile/build/package steps | 10 |
| 5 | Test Execution | Automated tests run with visible pass/fail results | 10 |
| 6 | Versioned Deployment Artifact | Produces versioned deployable output (major.minor.changelist) | 10 |
| 7 | SWOT Analysis | Provides complete SWOT comparison of two tools | 10 |
| 8 | Configuration Files | Explains YAML/config files used for automation | 10 |
| 9 | Demo Quality | Clarity, professionalism, and completeness of demonstration | 10 |
| 10 | Cloud Execution | Shows cloud-based execution + system load changes | 10 |
| Bonus | Reverse Documentation Output | Includes tool-generated architecture diagrams from source code | +5 |

---

## 2. Final Project Report -- Group (due Thu Dec 17, 2026, 11:59 pm, 100 points, unlimited attempts)

Add a chapter describing your DevOps project documenting the setup of your complete DevOps pipeline. Call it: **Configuring and Running the DevOps Pipeline**

1. For each of the steps in the V-Curve Development Cycle use at least one tool for each process.
2. In at least one place select two different tools and compare them using the SWOT (Strengths, Weaknesses, Opportunities, Threats) chart for each tool. The DevOps steps we want to cover are:
   - a) Issue tracking: Bugzilla, Jira, Github, GitLab, or others.
   - b) Source control: Git, GitHub, GitLab, Perforce, CVS, SVN, or others.
   - c) Architecture Forward Documentation: Overleaf, or other LaTeX compiler tools. No need to worry about addressing UML drawing tools, but if you want, you can.
   - d) CI/CD Tools: Things that run your entire pipeline: GitHub Actions, Jenkins, CircleCI, Tavis CI, etc.
   - e) Testing Tools: Pytest, Jest, JUnit, Mocha+Chai, Unittest, etc.
   - f) Deployment: Docker, Docker Compose, a Zip file with your package, etc.
   - g) A tool for monitoring aspects of your process: Jenkins, Prometheus + Grafana, etc.
   - h) Extra Credit: Architecture Reverse Documentation tools: Doxygen+Graphviz, Eclipse UML Generators, Visual Studio Class Designer, Pyreverse (part of Pylint), TypeScript PlantUML, others. Integrate the generation of documentation from code, using one of your Architecture Reverse Documentation tools.
3. Create or use an existing project, in any language or with any stack you prefer. Your project needs to contain the architecture documentation + some deployable code. It does not need to be complex.
4. Demo the complete start-to-finish pipeline, running in real time. You can run this on your own laptop, GitHub, on AWS, Digital Ocean, or a combination of any services. These are the steps of the demo:
   - a) Make a change to your Overleaf document or to your source code and show an issue entry in your issue tracking tool.
   - b) Submit it to a source control (i.e. most likely GitHub)
   - c) Either automatically or manually start a script/action/button press.
   - e) A process should show progress of the pipeline: compiling latex report + your project code (and/or zip project files)
   - f) A process runs some tests related to your project and reports pass results.
   - g) (+5 points) Bonus if processes are running on Digital Ocean and we see the server loads change as processes are running and stopping.
   - h) The output creates a versioned output major.minor.changelist, which could be a zip file.
   - i) (+5 bonus points) If the generated output contains the output of any Architecture Reverse Documentation tool.
5. The final output should have a deployable package (could be as simple as a ZIP file) that is versioned using: Major.Minor.Changelist.

### DevOps Report & Documentation Rubric: 100 points + 10 bonus
| # | Category | Description | Points |
|---|---|---|---|
| 1 | Issue Tracking | Uses issue tracker and submits relevant comment tied to work | 10 |
| 2 | Version Control Update | Meaningful change committed with appropriate message | 10 |
| 3 | CI/CD Pipeline Trigger | Demonstrates manual/automatic triggering of pipeline | 10 |
| 4 | Build Visibility | Pipeline clearly shows compile/build/package steps | 10 |
| 5 | Test Execution | Automated tests run with visible pass/fail results | 10 |
| 6 | Versioned Deployment Artifact | Produces versioned deployable output (major.minor.changelist) | 10 |
| 7 | SWOT Analysis | Provides complete SWOT comparison of two tools | 10 |
| 8 | Configuration Files | Documentation of YAML/config files used for automation | 10 |
| 9 | Report Quality | Clarity, professionalism, and completeness of report, including update history and links | 10 |
| Bonus | Cloud Execution | Shows configuration for cloud-based execution + system load changes | +5 |
| Bonus | Reverse Documentation Output | Includes documentation for configuring tool-generated architecture diagrams from source code | +5 |

(In the pasted rubric the report rubric lists 9 rows of 10 points plus two bonuses of 5; the text says 100 + 10 bonus.)
