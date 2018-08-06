//
//  ErrorMessages.swift
//  cau_study_ios
//
//  Created by CAUAD28 on 2018. 8. 6..
//  Copyright © 2018년 신형재. All rights reserved.
//

import Foundation
import Firebase

extension AuthErrorCode {
    var description: String? {
        switch self {
        case .emailAlreadyInUse:
            return "입력한 메일이 이미 존재합니다."
        case .userDisabled:
            return "본 계정은 중지되었습니다."
        case .operationNotAllowed:
            return "id 제공이 허용되어있지 않습니다."
        case .invalidEmail:
            return "이메일 형식으로 입력해주세요."
        case .wrongPassword:
            return "비밀번호가 올바르지 않습니다."
        case .userNotFound:
            return "계정을 찾을 수 없습니다."
        case .networkError:
            return "네트워크 연결을 확인해주세요."
        case .weakPassword:
            return "비밀번호 안정성이 낮습니다."
        case .missingEmail:
            return "Hace falta registrar un correo electrónico"
        case .internalError:
            return "내부오류가 발생했습니다."
        case .invalidCustomToken:
            return "Token personalizado invalido"
        case .tooManyRequests:
            return "서버로의 비정상적인 횟수의 요청이 감지되었습니다. 조금 후 다시 시도해주세요."
        default:
            return nil
        }
    }
}

//extension FirestoreErrorCode {
//    var description: String? {
//        switch self {
//        case .cancelled:
//            return "Operación cancelada"
//        case .unknown:
//            return "Error desconocido"
//        case .invalidArgument:
//            return "Argumento no valido"
//        case .notFound:
//            return "No se encotró el documento"
//        case .alreadyExists:
//            return "El documento que se pretende crear, ya existe"
//        case .permissionDenied:
//            return "No tienes permisos para realizar esta operación"
//        case .aborted:
//            return "Operación abortada"
//        case .outOfRange:
//            return "Rango invalido"
//        case .unimplemented:
//            return "Esta operación no ha sido implementada o no es soportada aún"
//        case .internal:
//            return "Error interno"
//        case .unavailable:
//            return "Por el momento el servicio no está disponible, intenta más tarde"
//        case .unauthenticated:
//            return "Usuario no autenticado"
//        default:
//            return nil
//        }
//    } }

extension StorageErrorCode {
    var description: String? {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .quotaExceeded:
            return "El espacio para guardar archivos ha sido sobrepasado"
        case .unauthenticated:
            return "사용자 인증이 되지 않았습니다. 인증 후 시도해주세요."
        case .unauthorized:
            return "사용자가 본 작업을 수행할 권한이 없습니다."
        case .retryLimitExceeded:
            return "작업시간이 초과되었습니다."
        case .downloadSizeExceeded:
            return "다운로드 가능한 사이즈를 초과하였습니다."
        case .cancelled:
            return "작업을 취소하였습니다."
        default:
            return nil
        }
    } }

public extension Error {
    var localizedDescription: String {
        let error = self as NSError
        if error.domain == AuthErrorDomain {
            if let code = AuthErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
//        }else if error.domain == FirestoreErrorDomain {
//            if let code = FirestoreErrorCode(rawValue: error.code) {
//                if let errorString = code.description {
//                    return errorString
//                }
//            }
        }else if error.domain == StorageErrorDomain {
            if let code = StorageErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        }
        return error.localizedDescription
    } }

