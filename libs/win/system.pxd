from c_windows cimport DSROLE_PRIMARY_DOMAIN_INFO_BASIC

IF UNAME_SYSNAME == "Windows":
    cdef bint _get_domain_info(DSROLE_PRIMARY_DOMAIN_INFO_BASIC **info)
