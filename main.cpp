/*
 * The MIT License (MIT)
 *
 * Copyright © 2023-2025 Stephen G. Tuggy
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#define PY_SSIZE_T_CLEAN
//#include <Python.h>
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
