#!/usr/bin/env bash

# Make sure sort works predictably.
export LC_ALL=C

cat <<EOF
# Maintainers

## General maintainers

- Jan-Otto Kröpke (<github@jkroepke.de> / @jkroepke)
- Mohammad Abubaker (<sheikhabubaker761@gmail.com> / @Sheikh-Abubaker)
- Aviv Guiser (<avivguiser@gmail.com> / @KyriosGN0)
- Quentin Bisson (<quentin@giantswarm.io> / @QuentinBisson)
- Michael Timmerman (<mike1118@live.com> / @TheRealNoob)
- Ilia Lazebnik (<Ilia.lazebnik@gmail.com / @DrFaust92)

## GitHub Workflows & Renovate maintainers

- Jan-Otto Kröpke (<github@jkroepke.de> / @jkroepke)
- Michael Timmerman (<mike1118@live.com> / @TheRealNoob)

## Helm charts maintainers
EOF

yq_script='"\n### " + .name + "\n\n" + ([.maintainers[] | "- " + .name + " (" + (("<" + .email + ">") // "unknown") + " / " + (.url | sub("https://github.com/", "@") + ")")] | sort | join("\n"))'
yq e "${yq_script}" charts/*/Chart.yaml
