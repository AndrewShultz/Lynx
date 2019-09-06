#!/bin/bash

KuapCopy()###USE###
{
    scp $KUAPLOG:$1 $2
}

CopyToKuap()###USE###
{
    scp $1 $KUAPLOG:$2
}
