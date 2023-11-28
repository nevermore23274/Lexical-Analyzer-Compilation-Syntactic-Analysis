# Lexical-Analyzer-Compilation-Syntactic-Analysis

# General Usage
- From the root directory you'll run:
```
docker build -t syntactic-analysis:latest -f docker/Dockerfile .
```
- Then you'll run:
```
docker run --name syntactic-analysis -v <location_to_root_folder>:/syntactic-analysis -it syntactic-analysis
```
- Once inside container and ready to test:
```
./compile < <filename>.txt
```
