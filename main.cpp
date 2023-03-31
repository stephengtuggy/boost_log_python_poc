#define PY_SSIZE_T_CLEAN
#include <Windows.h>
#include <Python.h>
#include "boost/python.hpp"
#include "boost/log/trivial.hpp"

int main() {
    BOOST_LOG_TRIVIAL(info) << "Initializing";

    Py_Initialize();

    try {
        boost::python::object main_module = boost::python::import("__main__");
        boost::python::object main_namespace = main_module.attr("__dict__");
        BOOST_LOG_TRIVIAL(info) << "Running Python snippet";
        boost::python::object ignored = boost::python::exec("print(\"Hello world from Python!\")", main_namespace);
    } catch (const boost::python::error_already_set&) {
        BOOST_LOG_TRIVIAL(error) << "Python error occurred";
        PyErr_Print();
        return 1;
    }

    BOOST_LOG_TRIVIAL(info) << "Shutting down normally";

    return 0;
}
