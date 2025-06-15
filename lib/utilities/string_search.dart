bool stringSearch(String target, String search)
{
  target = target.toLowerCase();
  search = search.toLowerCase();
  int len = target.length - search.length;

  for (int j = 0; j < len; j += 1)
  {
    bool found = true;
    for (int i = 0; i < search.length; i += 1)
      if (target[j + i] != search[i]) 
      {
        found = false;
        break;
      }

    if (found)
      return true;
  }

  return false;
}