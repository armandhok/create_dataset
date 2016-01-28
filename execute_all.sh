#! /bin/bash

echo -e "start\n" &&  ./webService.R && echo -e "finished stage 1\n" && ./get.sh && echo -e "finished stage 2\n" && ./process.R && echo -e "DONE\n"
