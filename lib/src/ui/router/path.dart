enum AppPath{
    home('/'),
    nearest('/nearest'),
    loads('/loads'),
    chat('/chat'),
    settings('/settings'),
    createLocationOnMap('createLocationsOnMap'),
    createData('createData')
    ;

    final String path;
    const AppPath(this.path);
}