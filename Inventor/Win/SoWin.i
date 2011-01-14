%extend SoWin {
  static void mainLoop(void) {
    PyRun_SimpleString("import sys");
    PyObject *d = PyModule_GetDict(PyImport_AddModule("__main__"));
    PyObject *result = PyRun_String("sys.argv[0]", Py_eval_input, d, d);
    /* if we are calling from within an interactive python interpreter
     * session spawn a new InteractiveLoop in a new thread. determined
     * by sys.argv[0] == ''. otherwise proceed as usual.
     */
    if (!strcmp(PyString_AsString(result), "")) {
      cc_thread *py_thread = cc_thread_construct(Pivy_PythonInteractiveLoop, NULL);
      SoWin::mainLoop();
      void *retval = NULL;
      cc_thread_join(py_thread, &retval);
      cc_thread_destruct(py_thread);
      Py_Exit(0);
    } else {
      SoWin::mainLoop();
    }
  }
}
