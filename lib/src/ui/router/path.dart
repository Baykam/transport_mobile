enum AppPath{
    home('/'),
    nearest('/nearest'),
    loads('/loads'),
    chat('/chat'),
    settings('/settings'),
    createLocationOnMap('createLocationsOnMap'),
    createData('createData'),
    loadDetail('loadDetails/:id'),
    filterLoads('filterLoads'),
    ;

    final String path;
    const AppPath(this.path);
}