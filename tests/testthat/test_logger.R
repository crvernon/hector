context('Test logging functionality')

inputdir <- system.file('input', package = 'hector')


test_that('Write out logs', {

    ## Turn logging ON for one test and confirm it runs (see GitHub issues #372 and #381)
    hc_log <- newcore(file.path(inputdir, "hector_rcp45.ini"), name = "RCP45", suppresslogging = FALSE)
    run(hc_log, 2100)
    shutdown(hc_log)

    # file path to the current directory where the package is stored
    run_dir <- dirname(here::here())

    # check for running tests locally; otherwise switch to CI paths
    local_dir <- file.path(run_dir, 'hector', 'tests', 'testthat', 'logs')
    if (dir.exists(local_dir)) {
        log_dir <- local_dir
    } else {

        # check for Unix file system otherwise assume Windows
        if (.Platform$OS.type == 'unix') {
            log_dir <- file.path(run_dir, 'hector', 'check', 'hector.Rcheck', 'tests', 'testthat', 'logs')
        } else {
            log_dir <- file.path(run_dir, 'hector', 'check', 'hector.Rcheck', 'tests_i386', 'testthat', 'logs')
        }
    }

    # look for the existence of the `logs` directory for Unix and Windows file systems
    expect_true(dir.exists(log_dir))

    # Check to see that individual log files were written out
    expect_equal(length(list.files(log_dir, pattern = '.log')), 41)

    # Check that errors on shutdown cores get caught
    expect_error(getdate(hc_log), "Invalid or inactive")
    expect_error(run(hc_log), "Invalid or inactive")
    expect_error(fetchvars(hc_log), "Invalid or inactive")
})
