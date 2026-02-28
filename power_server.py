#!/usr/bin/env python3

from concurrent import futures
import subprocess
from time import sleep
import grpc
from amdsmi import amdsmi_get_processor_handles, amdsmi_get_gpu_kfd_info, amdsmi_init, amdsmi_shut_down
import logging
logger = logging.getLogger(__name__)

protos, services = grpc.protos_and_services("power.proto")

amdsmi_init()
devices = amdsmi_get_processor_handles()
gpu_ids = {}
for i, device in enumerate(devices):
    gpu_ids[amdsmi_get_gpu_kfd_info(device)['node_id']-2] = i
amdsmi_shut_down()


def get_gpu_num(x): return gpu_ids[x]


def set_power(gpu_num, value):
    logger.info(f"SERVER: setting GPU{gpu_num} power cap to: {value} W")
    result = subprocess.run(
        f'sudo set_powercap.sh -value {str(value)} -gpu {str(gpu_num)}',
        executable="/bin/bash",
        shell=True,
    )
    return result.returncode


class PowerServer(services.PowerServerServicer):
    def SetPower(self, request, context):
        for tries in range(5, 0, -1):
            ret = set_power(get_gpu_num(request.gpu), request.watts)
            if ret == 0:
                return protos.PowerAck(ack=0)
            logger.warning(f"Failed, {tries} tries left...")
            sleep(2)
        logger.error("Failed, no tries left")
        return protos.PowerAck(ack=ret)


def serve():
    logger.info("Started serving")
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=1))
    services.add_PowerServerServicer_to_server(PowerServer(), server)
    server.add_insecure_port("unix:///tmp/power.sock")
    server.start()
    server.wait_for_termination()
    return 0


if __name__ == "__main__":
    logging.basicConfig(filename="power_server.log", level=logging.INFO)
    serve()
