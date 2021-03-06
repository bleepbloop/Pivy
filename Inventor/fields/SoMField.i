%ignore SoMField::get1(const int index, SbString & valuestring);

%extend SoMField {
/* extend __iter__ to return a new iterator object */
%pythoncode %{
   def __iter__(self):
      i = 0
      while i < self.getNum():
         yield self[i]
         i += 1
%}
  int __len__(void) { return self->getNum(); }

  /* a get1 method that returns a string as a result. */
  SbString get1(const int index) {
    SbString valuestring;
    self->get1(index, valuestring);
    return valuestring;
  }
}
