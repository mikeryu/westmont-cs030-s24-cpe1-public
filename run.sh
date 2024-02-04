#!/usr/bin/env bash

# Convenience script for Checkpoint Exam I, Programming Portion
# Author: Assistant Professor Mike Ryu <mryu@westmont.edu>

RED="\e[31m"
GRN="\e[32m"
YLO="\e[33m"
END="\e[0m"

# shellcheck disable=SC2059
printf "\n${YLO}Decrypting unit test source code ...${END}\n";
openssl enc -d -aes-256-cbc -pbkdf2 -in CheckpointExam1Test.enc -out CheckpointExam1Test.java;
IS_DEC_SUCCESS=$?

if [ $IS_DEC_SUCCESS -eq 0 ]; then
  # shellcheck disable=SC2059
  printf "\n${GRN}[PASS] Decryption successful!${END}\n\n";
else
  rm ./CheckpointExam1Test.java
  # shellcheck disable=SC2059
  printf "\n${RED}[FAIL] Decryption failed. Check password?${END}\n";
  exit 1;
fi

# shellcheck disable=SC2059
printf "\n${YLO}Compiling your code ...${END}\n";
javac -cp junit-platform-console-standalone-1.10.1.jar ./*.java;
IS_JAVAC_SUCCESS=$?

rm ./CheckpointExam1Test.java;
if [ $IS_JAVAC_SUCCESS -eq 0 ]; then
  # shellcheck disable=SC2059
  printf "\n${GRN}[PASS] Compilation successful!${END}\n\n";
else
  rm CheckpointExam1Test.java;
  # shellcheck disable=SC2059
  printf "\n${RED}[FAIL] Compilation error detected.${END}\n";
  exit 2;
fi

# shellcheck disable=SC2059
printf "\n${YLO}Running Instructor's Unit Tests ...${END}\n";
java -jar junit-platform-console-standalone-1.10.1.jar execute --classpath . --scan-class-path;
IS_TESTS_PASS=$?

rm ./*.class
if [ $IS_TESTS_PASS -eq 0 ]; then
  # shellcheck disable=SC2059
  printf "\n${GRN}[PASS] All unit tests passed!${END}\n\n";
  echo "Be sure to double check to make sure that"
  echo "your code satisfies all other requirements"
  echo "as well as following the style guidelines!"
else
  # shellcheck disable=SC2059
  printf "\n${RED}[FAIL] Unit test failure(s) detected.${END}\n";
  exit 3;
fi