#!/bin/bash

alias s="sudo su -"
alias ll="ls -l"
alias lr="ls -altr"

# Queue watching in HPC systems
alias qq="squeue -u ${_QUEUE_USERS}"
alias qc="scancel -u `whoami`"
alias qw="watch --interval 1 squeue -u ${_QUEUE_USERS}"
