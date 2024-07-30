hyprcl clients |
    awk '
        -F ' '
        BEGIN {
        print "Churning out only pid \n";
        ORS=" "
        }
        /nc|ncmpcpp/
        {print $0}
    '
