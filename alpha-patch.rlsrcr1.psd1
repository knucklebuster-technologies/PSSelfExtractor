
@{
    ModuleName   = 'PSScaffolding' 
    SourcePath   = '.'
    TestPath     = '.\tests'     
    ReleasePath  = '..\releases'
    BuildType = 'patch'
    PreReleaseTag = 'alpha.1'
    TaskSequence = @(
        'UpdateVersion'
        'GitAddAll'
    )
}
