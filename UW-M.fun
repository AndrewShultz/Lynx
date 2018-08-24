#!/bin/bash

WisconsinCopy()###USE###
{
    scp $WISC:CONDOR/$1 $2
}

CopyToWisconsin()###USE###
{
    scp $1 $WISC:CONDOR/
}
