#!/bin/bash
# AD2U V2
function getfullasciidoc() {
    while read line; do
        if [[ ${line} =~ include::.*\[\] ]]; then
            local deepfn=$(echo ${line} | sed "s/^include\:\://" | sed "s/\[\]$//")
            getfullasciidoc ${DN}/../doc/${deepfn}
        else
            echo "${line}"
        fi
    done <"${1}"
}
