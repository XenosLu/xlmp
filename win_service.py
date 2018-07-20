#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""deploy xlmp as windows service. Not suggested but works"""
import win32serviceutil  #pip install pywin32
import win32service
import win32event
import win32timezone
import os


class PythonService(win32serviceutil.ServiceFramework):
    """service in windows"""
    _svc_name_ = 'pyxlmp'
    _svc_display_name_ = 'PythonXLMP'
    _svc_description_ = 'Python XLMP Service'

    def __init__(self, args):
        super(PythonService, self).__init__(args)
        # win32serviceutil.ServiceFramework.__init__(self, args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)
        self.logger = self._getLogger()

    def _getLogger(self):
        import logging
        os.chdir(os.path.dirname(os.path.abspath(__file__)))  # set file path as current path
        logger = logging.getLogger('[PythonService]')
        # dirpath = os.path.abspath(os.path.dirname(__file__))
        # handler = logging.FileHandler(os.path.join(dirpath, 'service.log'))
        # formatter = logging.Formatter('%(asctime)s  %(name)-12s %(levelname)-8s %(message)s')
        # handler.setFormatter(formatter)
        # logger.addHandler(handler)
        # logger.setLevel(logging.INFO)

        logging.basicConfig(level=logging.INFO,
                            format='%(asctime)s %(filename)s %(levelname)s [line:%(lineno)d] %(message)s',
                            datefmt='%Y-%m-%d %H:%M:%S',
                            # filename=os.path.join(dirpath, 'service_test.log'),
                            filename='service.log',
                            filemode='a')
        return logger

    def auto_ins_module(self, mod):
        from imp import find_module
        try:
            find_module(mod)
        except ImportError as e:
            self.logger.warn(e)
            self.logger.info('%s installing...', mod)
            os.system('pip install %s' % mod)
            self.logger.info('install %s finished', mod)

    def SvcDoRun(self):
        # import logging
        # logging.info('test')
        self.logger.info('service is starting...')
        self.auto_ins_module('tornado')
        self.auto_ins_module('xmltodict')
        import tornado
        self.logger.info('tornado imported.')
        from xlmp import APP
        self.logger.info('web service imported.')
        APP.listen(8888, xheaders=True)
        self.inst = tornado.ioloop.IOLoop.instance()
        self.logger.info('service started.')
        self.inst.start()

    def SvcStop(self):
        self.logger.info('service is stopping...')
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)
        self.inst.add_callback(self.inst.stop)
        self.logger.info('service is stoped.')


if __name__ == '__main__':
    import sys
    import servicemanager
    if len(sys.argv) == 1:
        try:
            evtsrc_dll = os.path.abspath(servicemanager.__file__)
            servicemanager.PrepareToHostSingle(PythonService)
            servicemanager.Initialize('PythonService', evtsrc_dll)
            servicemanager.StartServiceCtrlDispatcher()
        except win32service.error as details:
            import winerror
            if details == winerror.ERROR_FAILED_SERVICE_CONTROLLER_CONNECT:
                win32serviceutil.usage()
    else:
        win32serviceutil.HandleCommandLine(PythonService)
    exe_path = win32serviceutil.LocatePythonServiceExe()
    # dll file path
    print(os.path.join(os.path.dirname(os.path.dirname(exe_path)), 'pywin32_system32', 'pywintypes36.dll'))
