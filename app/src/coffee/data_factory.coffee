app.factory 'DataFactory', () ->
  uuid = ->
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    chars = CHARS
    uuid = new Array(36)
    rnd = 0
    r = undefined
    i = 0
    while i < 36
      if i is 8 or i is 13 or i is 18 or i is 23
        uuid[i] = "-"
      else if i is 14
        uuid[i] = "4"
      else
        rnd = 0x2000000 + (Math.random() * 0x1000000) | 0  if rnd <= 0x02
        r = rnd & 0xf
        rnd = rnd >> 4
        uuid[i] = chars[(if (i is 19) then (r & 0x3) | 0x8 else r)]
      i++
    uuid.join ""

  userRoles = [
    {id: 1, role: 'User'}
    {id: 2, role: 'Admin'}
    {id: 3, role: 'SuperUser'}
  ]
  education = [
    {id: 1, name: 'SSC'}
    {id: 2, name: 'Intermediate'}
    {id: 3, name: 'UG'}
    {id: 4, name: 'PG'}
  ]
  constituencies = [
    {id: 1, name: 'Constituency 1'}
    {id: 2, name: 'Constituency 2'}
    {id: 3, name: 'Constituency 3'}
    {id: 4, name: 'Constituency 4'}
  ]
  gpus = [
    {id: 1, name: ' MelliDara Paiyong'}
  ]
  wards = [
    {id: 1, name: 'MelliDara'}
    {id: 2, name: 'MelliGumpa'}
    {id: 3, name: 'UpperPaiyong'}
    {id: 4, name: 'LowerPaiyong'}
    {id: 5, name: 'Kerabari'}
    {id: 6, name: 'MelliBazaar'}
  ]
  grievanceTypes = [
    {id: 1, name: 'Grievance Type 1'}
    {id: 2, name: 'Grievance Type 2'}
    {id: 3, name: 'Grievance Type 3'}
    {id: 4, name: 'Grievance Type 4'}
  ]
  departments = [
    {id: 1, name: 'Social Justice & Welfare'}
    {id: 2, name: 'Horticulture & Cash Crop Development'}
    {id: 3, name: 'Backward Region Grant Fund'}
    {id: 4, name: 'Rural Management & Development'}
    {id: 5, name: 'Animal Husbandry & Veterinary Services'}
    {id: 6, name: 'Livestock & Fisheries'}
    {id: 7, name: 'Human Resource Development'}
    {id: 8, name: 'Health care Human Services & Family Welfare'}
    {id: 9, name: 'Civil Supplies & Consumer Affairs'}
    {id: 10, name: 'Agriculture & Food Security Development'}
  ]
  schemes = [
    {id: 1, name: 'Green House'}
    {id: 2, name: 'Old Age Pension'}
    {id: 3, name: 'Indira Awas Yogna'}
    {id: 4, name: 'Widow Pension'}
    {id: 5, name: 'Subsistence Allowance'}
    {id: 6, name: 'Pre Metric Scholarship'}
    {id: 7, name: 'Post Metric Scholarship'}
    {id: 8, name: 'House Upgradation'}
    {id: 9, name: 'CMRHM'}
    {id: 10, name: 'Plastic Tasnk'}
    {id: 11, name: 'Cow Dung Pit'}
    {id: 12, name: 'Rural Housing Scheme'}
    {id: 13, name: 'LPG Cooking Gas Connection'}
    {id: 14, name: 'BPL Rice'}
    {id: 15, name: 'Education Scholarship'}
    {id: 16, name: 'GCI Sheet'}
  ]


  return {
    uuid: uuid
    userRoles: userRoles
    education: education
    constituencies: constituencies
    gpus: gpus
    wards: wards
    grievanceTypes: grievanceTypes
    departments: departments
    schemes: schemes
  }
