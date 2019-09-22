function ligossh

    # If no grid proxy is available, run ligo-proxy-init
    grid-proxy-info > /dev/null 2>&1
    if test "$status" -ne 0
        ligo-proxy-init tanner.prestegard
    end
    gsissh "$argv[1]"
end
