#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <boost/python.hpp>

int main() {
    Py_Initialize();

    try {
        boost::python::object main_module = boost::python::import("__main__");
        boost::python::object main_namespace = main_module.attr("__dict__");
        boost::python::object ignored = boost::python::exec("print(\"Hello world from Python!\")", main_namespace);
    } catch (const boost::python::error_already_set&) {
        PyErr_Print();
        return 1;
    }

    return 0;
}
