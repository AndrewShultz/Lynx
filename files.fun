#!/bin/bash

CONVERT_SVG_2_PDF()###USE###
{
rsvg-convert -f pdf -o $1.pdf $1.svg
}
